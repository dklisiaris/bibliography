# frozen_string_literal: true

# Concern for models that can have comments
# Replaces acts_as_commentable_with_threading
module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end

  # Returns all root comments (comments without a parent) for this commentable object
  # This replaces the comment_threads method from acts_as_commentable_with_threading
  def comment_threads
    comments.where(parent_id: nil).includes(:user, :children)
  end

  # Alias for comment_threads (for backward compatibility)
  # Some code may use root_comments instead of comment_threads
  alias_method :root_comments, :comment_threads
end

