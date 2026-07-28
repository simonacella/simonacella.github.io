# frozen_string_literal: true

# One static page per tag at /tag/<slug>.html (and /en|/fr under polyglot).

module Jekyll
  class TagPageGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.tags.each do |tag, _posts|
        site.pages << TagPage.new(site, site.source, tag)
      end
    end
  end

  class TagPage < Page
    def initialize(site, base, tag)
      @site = site
      @base = base
      @dir  = "tag"
      slug  = Utils.slugify(tag)
      @name = "#{slug}.html"

      process(@name)
      self.data = {}
      self.content = ""

      data["layout"] = "tag"
      data["title"] = tag
      data["tag_key"] = tag
      data["permalink"] = "/tag/#{slug}.html"
    end
  end
end
