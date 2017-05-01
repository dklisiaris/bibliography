# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://bibliography.gr"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add categories_path
  Category.find_each do |record|
    add category_path(record.id), lastmod: record.updated_at
  end

  add authors_path
  Author.find_each do |record|
    add author_path(record.id), lastmod: record.updated_at
  end

  add books_path
  add trending_books_path
  add awarded_books_path
  add latest_books_path
  add featured_books_path
  Book.find_each do |record|
    add book_path(record.id), lastmod: record.updated_at
  end

  add publishers_path
  Publisher.find_each do |record|
    add publisher_path(record.id), lastmod: record.updated_at
  end

  add series_index_path
  Series.find_each do |record|
    add books_path(series: record.name), lastmod: record.updated_at
  end
end
