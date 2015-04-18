class GeocodeWorker
  include Sidekiq::Worker
  sidekiq_options queue: :network_ops, retry: false

  def perform(place_id)
    place = Place.find(place_id)
    
    coordinates = Geocoder.coordinates(place.address)
    place.latitude = coordinates[0]
    place.longitude = coordinates[1]
    place.save!
  end 
end
