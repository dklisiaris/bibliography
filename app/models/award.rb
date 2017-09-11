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
