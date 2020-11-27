# frozen_string_literal: true

# :nodoc
class AuthorAvatarUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(author_id)
    author = Author.find(author_id)
    return unless author.image.present? && author.uploaded_avatar_url.nil?

    updated = author.update(remote_uploaded_avatar_url: author.image)
    puts "Avatar uploaded for author: #{author.id} - #{author.fullname}" if updated
    author.update(image: nil) if !updated && author.errors[:uploaded_avatar].present?
  end
end
