# frozen_string_literal: true

class BackupRatingsJob < MaintenanceJob
  # action can be one of ['like', 'unlike', 'dislike', 'undislike']
  def perform(user_id, rateable_id, rateable_type, action)
    rateable = rateable_type.constantize.find(rateable_id)
    user = User.find(user_id)

    case action
    when 'like'
      Rating.like(user, rateable)
    when 'unlike'
      Rating.unlike(user, rateable)
    when 'dislike'
      Rating.dislike(user, rateable)
    when 'undislike'
      Rating.undislike(user, rateable)
    else
      Rails.logger.warn "BackupRatingsJob: not acceptable action: #{action}"
    end

    Rails.logger.info "User #{user_id} #{action} #{rateable_type} #{rateable_id}"
  end
end
