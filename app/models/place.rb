class Place < ActiveRecord::Base
  belongs_to :placeable, polymorphic: true
  
  validates :address, presence: true
  
  geocoded_by :address
  
  after_validation :geocode, :if => :address_changed?

  # def geocode_in_background  
  #   GeocodeWorker.perform_async(self.id)
  # end

end
