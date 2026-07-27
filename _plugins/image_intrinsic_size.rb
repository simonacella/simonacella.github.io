# frozen_string_literal: true

# Add intrinsic width/height on <img> tags that point at local assets/img
# files, so the browser can reserve space (less CLS). Authors keep normal
# Markdown/Liquid; dimensions are read from source files at build time.
#
# On article pages (lazy: true), also mark below-the-fold local images with
# loading="lazy" decoding="async" so old phones / slow networks do not fetch
# every inline image up front. Cover images (class cover-image) and any img
# that already sets loading= stay eager. Other layouts are unchanged — the
# homepage already marks cards 3+ as lazy in Liquid.
#
# Production may later rewrite .jpg → .webp in _site; aspect ratio is unchanged
# when optimize-site-images.py only downscales with a max edge.

require "pathname"

module ImageIntrinsicSize
  IMG_TAG = /<img\b([^>]*?)>/im
  SRC_ATTR = /\bsrc\s*=\s*(["'])([^"']+)\1/i
  WIDTH_ATTR = /\bwidth\s*=\s*(["'])[^"']*\1/i
  HEIGHT_ATTR = /\bheight\s*=\s*(["'])[^"']*\1/i
  LOADING_ATTR = /\bloading\s*=/i
  DECODING_ATTR = /\bdecoding\s*=/i
  COVER_CLASS = /\bcover-image\b/

  module_function

  def inject(html, source_dir, lazy: false)
    cache = {}
    html.to_s.gsub(IMG_TAG) do |tag|
      attrs = Regexp.last_match(1)
      src_match = attrs.match(SRC_ATTR)
      next tag unless src_match

      src = src_match[2]
      next tag if src.start_with?("http://", "https://", "//", "data:")

      path = resolve(source_dir, src)
      next tag unless path && path.file?

      cleaned = attrs
      prefix = +""
      changed = false

      unless integer_dimensions?(cleaned)
        dims = (cache[path] ||= read_dimensions(path))
        if dims
          width, height = dims
          cleaned = cleaned.gsub(WIDTH_ATTR, "").gsub(HEIGHT_ATTR, "")
          # Also strip unquoted width/height if present
          cleaned = cleaned.gsub(/\bwidth\s*=\s*\d+/i, "").gsub(/\bheight\s*=\s*\d+/i, "")
          prefix = %( width="#{width}" height="#{height}")
          changed = true
        end
      end

      if lazy && deferrable?(cleaned)
        cleaned = with_lazy_loading(cleaned)
        changed = true
      end

      next tag unless changed

      %(<img#{prefix}#{cleaned}>)
    end
  end

  def deferrable?(attrs)
    !attrs.match?(LOADING_ATTR) && !attrs.match?(COVER_CLASS)
  end

  def with_lazy_loading(attrs)
    out = +attrs
    out << ' decoding="async"' unless out.match?(DECODING_ATTR)
    out << ' loading="lazy"'
    out
  end

  def integer_dimensions?(attrs)
    w = attrs[/\bwidth\s*=\s*(["']?)(\d+)\1/i, 2]
    h = attrs[/\bheight\s*=\s*(["']?)(\d+)\1/i, 2]
    !w.nil? && !h.nil?
  end

  def resolve(source_dir, src)
    # "./assets/...", "../assets/...", "/assets/...", "assets/..."
    relative = src.sub(%r{\A(\./)+}, "")
    relative = relative.sub(%r{\A(\.\./)+}, "") while relative.start_with?("../")
    relative = relative.sub(%r{\A/}, "")
    candidate = (Pathname.new(source_dir) + relative).cleanpath
    candidate.file? ? candidate : nil
  end

  # Dispatch on the magic bytes, not the extension: authors sometimes save a
  # PNG as .jpg, and trusting the name silently yields no dimensions (no
  # width/height attribute, so the image causes layout shift).
  def read_dimensions(path)
    File.open(path, "rb") do |io|
      head = io.read(32)
      return nil if head.nil? || head.bytesize < 24

      case detect_format(head)
      when :png
        png_size(head)
      when :jpeg
        io.seek(0)
        jpeg_size(io)
      when :webp
        io.seek(0)
        webp_size(io, head)
      end
    end
  rescue StandardError
    nil
  end

  def detect_format(head)
    return :png if head.start_with?("\x89PNG\r\n\x1a\n".b)
    return :jpeg if head.start_with?("\xFF\xD8".b)
    return :webp if head[0, 4] == "RIFF" && head[8, 4] == "WEBP"

    nil
  end

  def png_size(head)
    return nil unless head.start_with?("\x89PNG\r\n\x1a\n".b)

    # IHDR: 8 signature + 4 length + 4 "IHDR" + 4 width + 4 height
    width = head[16, 4].unpack1("N")
    height = head[20, 4].unpack1("N")
    [width, height]
  end

  def jpeg_size(io)
    return nil unless io.read(2) == "\xFF\xD8".b

    loop do
      marker = io.read(2)
      return nil if marker.nil? || marker.bytesize < 2
      return nil unless marker.getbyte(0) == 0xFF

      code = marker.getbyte(1)
      code = io.readbyte while code == 0xFF

      # Standalone markers with no segment length
      next if [0xD8, 0xD9].include?(code) # SOI/EOI (shouldn't appear mid-stream)
      break if code == 0xDA # SOS — too late

      len_bytes = io.read(2)
      return nil if len_bytes.nil? || len_bytes.bytesize < 2

      length = len_bytes.unpack1("n")
      return nil if length < 2

      # SOF0–SOF3, SOF5–SOF7, SOF9–SOF11, SOF13–SOF15
      if (0xC0..0xCF).cover?(code) && ![0xC4, 0xC8, 0xCC].include?(code)
        segment = io.read(length - 2)
        return nil if segment.nil? || segment.bytesize < 5

        height = segment[1, 2].unpack1("n")
        width = segment[3, 2].unpack1("n")
        return [width, height]
      end

      io.seek(length - 2, IO::SEEK_CUR)
    end
    nil
  end

  def webp_size(io, head)
    return nil unless head[0, 4] == "RIFF" && head[8, 4] == "WEBP"

    io.seek(12)
    until io.eof?
      chunk = io.read(8)
      break if chunk.nil? || chunk.bytesize < 8

      tag, size = chunk.unpack("a4V")
      data = io.read(size)
      break if data.nil?

      io.read(1) if size.odd? # padding

      case tag
      when "VP8X"
        return nil if data.bytesize < 10

        # 24-bit width/height minus one, little-endian
        w = data.getbyte(4) | (data.getbyte(5) << 8) | (data.getbyte(6) << 16)
        h = data.getbyte(7) | (data.getbyte(8) << 8) | (data.getbyte(9) << 16)
        return [w + 1, h + 1]
      when "VP8 "
        # lossy bitstream: sync code 0x9d012a at byte 3 of frame
        return nil if data.bytesize < 10
        next unless data[3, 3] == "\x9d\x01\x2a".b

        bits = data[6, 4].unpack1("V")
        width = bits & 0x3FFF
        height = (bits >> 16) & 0x3FFF
        return [width, height]
      when "VP8L"
        return nil if data.bytesize < 5
        next unless data.getbyte(0) == 0x2F

        bits = data[1, 4].unpack1("V")
        width = (bits & 0x3FFF) + 1
        height = ((bits >> 14) & 0x3FFF) + 1
        return [width, height]
      end
    end
    nil
  end
end

if defined?(Jekyll)
  Jekyll::Hooks.register [:pages, :documents], :post_render do |item|
    next unless item.output

    lazy = item.data["layout"] == "post"
    item.output = ImageIntrinsicSize.inject(item.output, item.site.source, lazy: lazy)
  end
end
