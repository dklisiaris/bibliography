class Place < ActiveRecord::Base
  belongs_to :placeable, polymorphic: true
end
