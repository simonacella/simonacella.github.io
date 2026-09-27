# frozen_string_literal: true

# Downcase every post tag in memory so Cinema / cinema share one key and one
# /tag/<slug>.html page. Disk files are unchanged. Visible UI already uses
# text-transform: lowercase on tag clouds and tag headings.

module Jekyll
  module CanonicalizeTags
    module_function

    def normalize_site!(site)
      site.posts.docs.each do |doc|
        tags = doc.data["tags"]
        next unless tags.is_a?(Array) && !tags.empty?

        doc.data["tags"] = tags.map { |t| t.to_s.downcase }.uniq
      end

      # site.tags is memoized from post data; force rebuild after rewrite.
      site.instance_variable_set(:@post_attr_hash, {})
    end
  end
end

Jekyll::Hooks.register :site, :post_read, priority: :high do |site|
  Jekyll::CanonicalizeTags.normalize_site!(site)
end
