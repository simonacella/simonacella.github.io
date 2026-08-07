# frozen_string_literal: true

# Polyglot’s default: if IT/EN/FR share a URL and a translation file is missing,
# the Italian post is still published under /en/ and /fr/ (same path, Italian
# body). That makes “switch language” show Italian. After coordinate, drop posts
# whose front-matter lang is not the active language so missing translations
# simply do not appear (listings + direct URL).

Jekyll::Hooks.register :site, :post_read, priority: :low do |site|
  next if site.active_lang.nil? || site.active_lang == site.default_lang

  site.posts.docs.select! do |doc|
    lang = doc.data["lang"].to_s
    lang.empty? || lang == site.active_lang
  end
end
