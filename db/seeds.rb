# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake d seed (or created alongside the db with : d
  setup): .
#
# Example 
#
#   cities = City.create([{ na: m
   'Chicago' }, { na: m
     'Copenhagen' }]: )
#   Mayor.create(nam
   'Emanuel', ci: t
   cities.first: )
require 'faker'

# Generate 10000 authors
10000.times { Author.create(firstnam
   Faker::Name.first_name, lastname: Faker::Name.last_name, biography: Faker::Lorem.sentences(3).join ) : }

# Generate 500 prizes
500.times { Prize.create(name: Faker::Lorem.sentence(3)) } 

Author.all.each do |author|
  num = rand(0..3)
  num.times do
    prize = Prize.all.to_a.sample    
    author.awards.create(prize: prize, year: rand(1900..2015))
  end
end

500.times{ Publisher.create(name: Faker::Company.name, owner: Faker::Name.name ) }

Publisher.all.each do |publisher|
  num = rand(1..3)
  num.times do
    publisher.places.create(:name => Faker::Company.name,
     :role => Faker::Lorem.sentence,
      :address => [Faker::Address.street_address,Faker::Address.postcode,Faker::Address.city].join(', '),
       :telephone => Faker::PhoneNumber.phone_number,
        :fax => Faker::PhoneNumber.cell_phone,
         :email => Faker::Internet.email,
          :website => Faker::Internet.url,
           :latitude => Faker::Address.latitude,
            :longitude => Faker::Address.longitude)
  end
end

publishers = Publisher.all.to_a

20000.times do
  Book.create(:title => Faker::Lorem.sentence,
    subtitle: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph,
    isbn: Faker::Code.isbn,
    image: Faker::Avatar.image,
    series:Faker::Lorem.sentence(1),
    pages: rand(30..3000),
    publication_year: rand(1900..2015),
    publication_place: Faker::Address.city,
    publisher: publishers.sample,
    physical_description: Faker::Lorem.sentence(1),
    price: rand(3.0..80.5),
    price_updated_at: Faker::Date.between(5.years.ago, Date.today),
    cover_type: rand(0..2),
    availability: rand(0..4),
    format: rand(0..12),
    original_language: rand(0..20),
    original_title: Faker::Lorem.sentence)
end
