# frozen_string_literal: true

# :nodoc
class BookCoverOgGeneratorWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(book_id)
    book = Book.find(book_id)
    return unless book.uploaded_cover_url.present?

    cover_path = Rails.public_path.to_s + book.cover
    
    # Validate file exists and is a valid image
    unless File.exist?(cover_path)
      Rails.logger.warn "BookCoverOgGeneratorWorker: Cover file not found: #{cover_path} for book #{book_id}"
      return
    end

    # Check if file is actually an image (not HTML/XML/error page)
    begin
      image = MiniMagick::Image.open(cover_path)
      image.valid? # This will raise if not a valid image
    rescue MiniMagick::Invalid => e
      Rails.logger.error "BookCoverOgGeneratorWorker: Invalid image file #{cover_path} for book #{book_id}: #{e.message}"
      return
    end

    og_cover_path = cover_path.gsub('.jpg', '_og.jpg')
    puts "Generating og cover in #{og_cover_path}"

    image.resize(image.dimensions.map { |d| (d * 1.35).floor }.join('x'))
    image.write(og_cover_path)
  end
end
