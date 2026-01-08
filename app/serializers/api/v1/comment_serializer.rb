class Api::V1::CommentSerializer < Api::V1::BaseSerializer
  # Removed :lft and :rgt as we're no longer using nested set (acts_as_nested_set)
  # Using simple parent_id-based threading instead
  attributes :id, :title, :body, :subject, :user_id, :user_screen_name, :user_avatar, :parent_id

  # belongs_to :commentable_id

  def user_screen_name
    object.user.screen_name
  end

  def user_avatar
    object.user.avatar
  end
end
