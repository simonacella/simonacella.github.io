source 'https://rubygems.org'

# Declared so Renovate can bump Bundler (BUNDLED WITH alone is not an update target).
gem 'bundler', '~> 4.0', '>= 4.0.17'

# Only gems this site chooses. Transitive deps (csv, kramdown, …) stay in
# Gemfile.lock via Jekyll/plugins; Renovate lockfile maintenance keeps them fresh.
gem 'jekyll', '~> 4.4.1'

group :jekyll_plugins do
  gem 'jekyll-paginate', '~> 1.1'
  gem 'jekyll-sitemap', '~> 1.4'
  gem 'jekyll-polyglot', '~> 1.13'
end
