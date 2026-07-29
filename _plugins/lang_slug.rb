# frozen_string_literal: true

# Jekyll's :title permalink token is the *filename* slug, not front-matter title.
# Files named …-Dao.en.md / …-Dao.fr.md would otherwise publish as /Dao.en.html
# and /Dao.fr.html. Polyglot pairs translations by URL, so those look like
# separate posts and the homepage/archive list every language at once.
# Strip a trailing .<lang> from the slug so IT/EN/FR share one permalink.
#
# Runs on site :post_read at high priority, before polyglot's coordinate hook.

module Jekyll
  module LangSlugNormalizer
    def self.normalize_site!(site)
      languages = Array(site.config["languages"]).map(&:to_s)
      return if languages.empty?

      suffix = /\.(#{Regexp.union(languages)})$/i
      site.posts.docs.each do |doc|
        slug = doc.data["slug"]
        next if slug.nil? || slug.empty? || !slug.match?(suffix)

        doc.data["slug"] = slug.sub(suffix, "")
        doc.instance_variable_set(:@url, nil)
        doc.instance_variable_set(:@url_placeholders, nil)
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_read, priority: :high do |site|
  Jekyll::LangSlugNormalizer.normalize_site!(site)
end
