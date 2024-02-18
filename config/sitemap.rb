# frozen_string_literal: true

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://xpensis.xyz"

SitemapGenerator::Sitemap.create do
  add "/", :changefreq => "daily"
  add "/terms", :changefreq => "daily"
  add "/privacy", :changefreq => "daily"
end
