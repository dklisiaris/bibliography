class Award < ActiveRecord::Base
  belongs_to :prize
  belongs_to :awardable, polymorphic: true

  default_scope { order('year DESC') }
end
