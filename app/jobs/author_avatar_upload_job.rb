# frozen_string_literal: true

class AuthorAvatarUploadJob < MaintenanceJob
  def perform(author_id)
    author = Author.find(author_id)
    return unless author.image.present? && author.uploaded_avatar_url.nil?

    updated = author.update(remote_uploaded_avatar_url: author.image)
    Rails.logger.info "Avatar uploaded for author: #{author.id} - #{author.fullname}" if updated
    author.update(image: nil) if !updated && author.errors[:uploaded_avatar].present?
  end
end
