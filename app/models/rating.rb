class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  enum rate: %i(like dislike hide)

  validates :user_id, presence: true
  validates :rateable_id, presence: true
  validates :rateable_type, presence: true
  validates :user_id, presence: true
  validates :user_id, :uniqueness => { :scope => [:rateable_type, :rateable_id] }
  validates :rate, presence: true

  def self.like(user, rateable)
    rateable.ratings.create(user_id: user.id, rate: 0)
  end

  def self.unlike(user, rateable)
    self.where(user_id: user.id, rateable_id: rateable.id, rateable_type: rateable.type, rate: 0).destroy
  end

  def self.dislike(user, rateable)
    rateable.ratings.create(user_id: user.id, rate: 1)
  end

  def self.undislike(user, rateable)
    self.where(user_id: user.id, rateable_id: rateable.id, rateable_type: rateable.type, rate: 1).destroy
  end
end

# == Schema Information
#
# Table name: ratings
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  rateable_id   :integer          not null
#  rateable_type :string           not null
#  rate          :integer          not null
#  bookmark      :boolean          default(FALSE)
#
# Indexes
#
#  fk_rateables              (rateable_id,rateable_type)
#  index_ratings_on_user_id  (user_id)
#
