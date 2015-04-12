# class GeocodeWorker
#   include Sidekiq::Worker
#   sidekiq_options retry: false

#   def perform(place_id)
#     place = Place.find(place_id)
#     # place.geocode

#     # coordinates = Geocoder.coordinates(place.address)
#     # place.latitude = coordinates[0]
#     # place.longitude = coordinates[1]
#     # place.save!
#   end 
# end