class Comment < ActiveRecord::Base
  # Replaced acts_as_nested_set with simple parent/children relationships
  # This is compatible with Rails 6.0+
  
  validates :body, :presence => true
  validates :user, :presence => true
  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_votable

  belongs_to :commentable, :polymorphic => true

  # NOTE: Comments belong to a user
  belongs_to :user

  # Parent-child relationships for threaded comments
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  # Scope to get root comments (no parent)
  scope :roots, -> { where(parent_id: nil) }

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    new \
      :commentable => obj,
      :body        => comment,
      :user_id     => user_id
  end

  # Helper method to check if a comment has children
  def has_children?
    children.exists?
  end

  # Check if this is a root comment (no parent)
  def root?
    parent_id.nil?
  end

  # Move this comment to be a child of the given parent comment
  # Replaces move_to_child_of from acts_as_nested_set
  def move_to_child_of(parent_comment)
    update(parent_id: parent_comment.id)
  end

  # Get the depth of this comment in the thread (0 for root)
  def depth
    return 0 if root?
    parent.depth + 1
  end

  # Get all ancestors (parent, grandparent, etc.)
  def ancestors
    return [] if root?
    [parent] + parent.ancestors
  end

  # Get all descendants (children, grandchildren, etc.)
  def descendants
    children + children.flat_map(&:descendants)
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
end

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string
#  title            :string
#  body             :text
#  subject          :string
#  user_id          :integer          not null
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_comments_on_commentable_id_and_commentable_type  (commentable_id,commentable_type)
#  index_comments_on_user_id                              (user_id)
#
