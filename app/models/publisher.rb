class Publisher < ActiveRecord::Base
  has_many :places, as: :placeable
end
