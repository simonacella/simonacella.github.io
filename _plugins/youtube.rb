# frozen_string_literal: true

# {% youtube "https://youtu.be/…" %} — render _includes/youtube.html with a
# video id. Bad URLs in posts are caught by content_lint; here we just skip.

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
      return "" if id.nil?

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
