class Award < ActiveRecord::Base
  belongs_to :prize
  belongs_to :awardable, polymorphic: true

  # default_scope { order('year DESC') }
  def self.most_awarded_book_ids(limit = 8)
    self.where(awardable_type: 'Book')
      .select('awards.awardable_id, awards.awardable_type, sum(awards.id) as awards_count')
      .group('awards.awardable_id, awards.awardable_type')
      .order('awards_count desc')
      .limit(limit)
      .map {|award| award.awardable_id}
  end

  def self.random_awarded_book_ids(limit = 8)
    self.where(awardable_type: 'Book')
      .order('RANDOM()')
      .limit(limit)
      .map {|award| award.awardable_id}
  end

  def self.random_awarded_author_ids(limit = 8)
    self.where(awardable_type: 'Author')
      .order('RANDOM()')
      .limit(limit)
      .map {|award| award.awardable_id}
  end
end

# == Schema Information
#
# Table name: awards
#
#  id             :integer          not null, primary key
#  prize_id       :integer
#  year           :integer
#  awardable_id   :integer
#  awardable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_awards_on_awardable_id_and_awardable_type  (awardable_id,awardable_type)
#  index_awards_on_prize_id                         (prize_id)
#
# Foreign Keys
#
#  fk_rails_...  (prize_id => prizes.id)
#
