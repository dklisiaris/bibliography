# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://bibliography.gr'

SitemapGenerator::Sitemap.create do
  add categories_path
  Category.find_each do |record|
    add category_path(record.slug), lastmod: record.updated_at
  end

  add authors_path
  Author.find_each do |record|
    add author_path(record.slug), lastmod: record.updated_at
  end

  add books_path
  add trending_books_path
  add awarded_books_path
  add latest_books_path
  add featured_books_path
  add pages_about_path
  add pages_privacy_policy_path
  Book.find_each do |record|
    add book_path(record.slug), lastmod: record.updated_at
  end

  add publishers_path
  Publisher.find_each do |record|
    add publisher_path(record.slug), lastmod: record.updated_at
  end

  add series_index_path
  Series.find_each do |record|
    add books_path(series: record.name), lastmod: record.updated_at
  end
end
