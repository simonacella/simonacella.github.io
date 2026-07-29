# frozen_string_literal: true

# jekyll-sitemap + polyglot emit /en/sitemap.xml and /fr/sitemap.xml that are
# byte-identical to the Italian sitemap (Italian URLs only). robots.txt already
# points at the root sitemap; drop the misleading localized copies.

Jekyll::Hooks.register :site, :post_write do |site|
  next if site.active_lang == site.default_lang

  path = File.join(site.dest, "sitemap.xml")
  File.delete(path) if File.file?(path)
end
