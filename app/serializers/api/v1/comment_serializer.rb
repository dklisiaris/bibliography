class Api::V1::CommentSerializer < Api::V1::BaseSerializer
  attributes :id, :title, :body, :subject, :user_id, :user_screen_name, :user_avatar, :parent_id, :lft, :rgt

  # belongs_to :commentable_id

  def user_screen_name
    object.user.screen_name
  end

  def user_avatar
    object.user.avatar
  end
end
