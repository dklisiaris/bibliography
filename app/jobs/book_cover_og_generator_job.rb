# frozen_string_literal: true

class BookCoverOgGeneratorJob < MaintenanceJob
  def perform(book_id)
    book = Book.find(book_id)
    return unless book.uploaded_cover_url.present?

    cover_path = Rails.public_path.to_s + book.cover

    unless File.exist?(cover_path)
      Rails.logger.warn "BookCoverOgGeneratorJob: Cover file not found: #{cover_path} for book #{book_id}"
      return
    end

    begin
      image = MiniMagick::Image.open(cover_path)
      image.valid?
    rescue MiniMagick::Invalid => e
      Rails.logger.error "BookCoverOgGeneratorJob: Invalid image file #{cover_path} for book #{book_id}: #{e.message}"
      return
    end

    og_cover_path = cover_path.gsub('.jpg', '_og.jpg')
    Rails.logger.info "Generating og cover in #{og_cover_path}"

    image.resize(image.dimensions.map { |d| (d * 1.35).floor }.join('x'))
    image.write(og_cover_path)
  end
end
