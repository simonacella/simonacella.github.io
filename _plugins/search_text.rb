# frozen_string_literal: true

# Strip HTML for search indexing without gluing adjacent words.
# Jekyll's strip_html removes tags with nothing in between, so
# "</p><p>" becomes "" and "end.start" fuses across paragraph breaks.
# Replacing every tag with a space covers all elements, not a tag list.

module Jekyll
  module SearchTextFilter
    def searchable_text(input)
      input.to_s
           .gsub(/<[^>]+>/, " ")
           .gsub(/\s+/, " ")
           .strip
    end
  end
end

Liquid::Template.register_filter(Jekyll::SearchTextFilter)
