class BookCoverOgGeneratorWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(book_id)
    book = Book.find(book_id)
    if book.uploaded_cover_url.present?
      cover_path = Rails.public_path.to_s + book.cover
      og_cover_path = cover_path.gsub('.jpg', '_og.jpg')
      puts "Generating og cover in #{og_cover_path}"

      image = MiniMagick::Image.open(cover_path)
      image.resize(image.dimensions.map{|d| (d*1.35).floor}.join('x'))
      image.write(og_cover_path)
    end
  end

end
