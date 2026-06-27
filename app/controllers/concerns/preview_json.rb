# frozen_string_literal: true

module PreviewJson
  extend ActiveSupport::Concern

  private

  def preview_json(records, type)
    records.map { |record| public_send("#{type}_preview_json", record) }
  end

  def search_results_preview_json(search_results)
    results = {}

    search_results.each do |result|
      key = result.klass.to_s.underscore.pluralize.to_sym
      type = result.klass.to_s.underscore
      results[key] = preview_json(result.results, type)
    end

    { results: results }
  end

  def book_preview_json(book)
    {
      id: book.id,
      title: book.title,
      subtitle: book.subtitle,
      description: book.short_description(100),
      image: book.uploaded_cover_url.presence || '/no_cover.jpg',
      likes_count: book.liked_by_count,
      dislikes_count: book.disliked_by_count,
      collections_count: book.bookshelves.count,
      views_count: book.views_count || 0,
      url: book_url(book),
      site_url: book_url(book),
      writers: preview_json(book.writers, :author),
      publisher: book.publisher.present? ? publisher_preview_json(book.publisher) : nil,
      categories: preview_json(book.categories, :category)
    }
  end

  def minimal_book_json(book)
    {
      id: book.id,
      title: book.title,
      subtitle: book.subtitle,
      description: book.short_description(100),
      cover: book.cover,
      url: book_url(book),
      site_url: book_url(book)
    }
  end

  def author_preview_json(author)
    {
      id: author.id,
      firstname: author.firstname,
      lastname: author.lastname,
      url: author_url(author),
      site_url: author_url(author),
      fullname: author.fullname,
      image: author.avatar
    }
  end

  def category_preview_json(category)
    {
      id: category.id,
      name: category.name,
      url: category_url(category),
      site_url: category_url(category)
    }
  end

  def category_with_books_json(category)
    category_preview_json(category).merge(
      ddc: category.ddc,
      slug: category.slug,
      biblionet_id: category.biblionet_id,
      featured: category.featured,
      books: category.books.where.not(image: nil).order(views_count: :desc).limit(12).map do |book|
        minimal_book_json(book)
      end
    )
  end

  def publisher_preview_json(publisher)
    {
      id: publisher.id,
      name: publisher.name,
      url: publisher_url(publisher),
      site_url: publisher_url(publisher)
    }
  end

  def series_preview_json(series)
    url = books_url(series: series.name)

    {
      id: series.id,
      name: series.name,
      url: url,
      site_url: url
    }
  end
end
