class AuthorAvatarUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(author_id)
    author = Author.find(author_id)
    if author.image.present? && author.uploaded_avatar_url.nil?
      if author.update(remote_uploaded_avatar_url: author.image)
        puts "Avatar uploaded for author: #{author.id} - #{author.fullname}"
      end
    end
  end

end
