# frozen_string_literal: true

# Drop unpublished EN/FR (no translation_public: true) before polyglot
# coordinate so available_languages / switcher / hreflang only list live langs.
#
# After coordinate, Italian fallbacks stay in site.posts so /en and /fr still
# list the full catalogue, but they are not written (published: false). Cards
# use post_link_attrs.html to send the visitor to the Italian URL.

module Jekyll
  module StripPostFallbacks
    module_function

    def posts(site)
      site.collections["posts"]
    end

    def lang_of(doc, default_lang)
      lang = doc.data["lang"].to_s
      lang.empty? ? default_lang : lang
    end

    def public?(doc, default_lang)
      lang_of(doc, default_lang) == default_lang || doc.data["translation_public"] == true
    end

    def drop_unpublished!(site)
      coll = posts(site)
      return if coll.nil?

      default = site.default_lang.to_s
      coll.docs.select! { |doc| public?(doc, default) }
    end

    def skip_writing_fallbacks!(site)
      return if site.active_lang.nil? || site.active_lang == site.default_lang

      coll = posts(site)
      return if coll.nil?

      active = site.active_lang.to_s
      default = site.default_lang.to_s
      coll.docs.each do |doc|
        next if lang_of(doc, default) == active

        doc.data["published"] = false
        doc.remove_instance_variable(:@write_p) if doc.instance_variable_defined?(:@write_p)
      end
      site.instance_variable_set(:@post_attr_hash, {})
    end
  end

  class StripPostFallbacksGenerator < Generator
    safe true
    priority :high

    def generate(site)
      StripPostFallbacks.skip_writing_fallbacks!(site)
    end
  end
end

# After lang_slug (:high, registered first), before polyglot coordinate (default).
Jekyll::Hooks.register :site, :post_read, priority: :high do |site|
  next if site.active_lang.nil?

  Jekyll::StripPostFallbacks.drop_unpublished!(site)
end
