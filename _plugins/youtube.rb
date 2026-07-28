# frozen_string_literal: true

# {% youtube "https://youtu.be/…" %} — extract the video id and render
# _includes/youtube.html through the live Liquid context (so locale / ui-text
# work). Replaces the jekyll-youtube gem, which rendered the include through a
# bare Liquid::Template with File.read and no encoding, blocking i18n and
# non-ASCII bytes.

module Jekyll
  class YouTubeTag < Liquid::Tag
    ID_RE = /\A[A-Za-z0-9_-]{11}\z/

    def initialize(tag_name, markup, tokens)
      super
      @markup = markup.strip
    end

    def render(context)
      url = Liquid::Variable.new(@markup, parse_context).render(context).to_s.strip
      id = extract_id(url)
      if id.nil?
        Jekyll.logger.warn "YouTube:", "could not parse video id from #{url.inspect} — skipping embed"
        return ""
      end

      site = context.registers[:site]
      path = site.in_source_dir("_includes", "youtube.html")
      raise "Missing _includes/youtube.html (needed by {% youtube %})" unless File.file?(path)

      template = site.liquid_renderer.file(path).parse(File.read(path, encoding: "UTF-8"))
      context.stack do
        context["youtube_id"] = id
        template.render!(context)
      end
    end

    private

    def extract_id(url)
      return nil if url.empty?
      return url if url.match?(ID_RE)

      if (m = url.match(%r{youtu\.be/([A-Za-z0-9_-]{11})}))
        return m[1]
      end

      if (m = url.match(%r{(?:v=|/embed/|/v/|/shorts/)([A-Za-z0-9_-]{11})}))
        return m[1]
      end

      nil
    end
  end
end

Liquid::Template.register_tag("youtube", Jekyll::YouTubeTag)
