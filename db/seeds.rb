# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

# Generate 100 authors
10000.times { Author.create(firstname: Faker::Name.first_name, lastname: Faker::Name.last_name, biography: Faker::Lorem.sentences(3).join ) }

# Generate 50 prices
500.times { Prize.create(name: Faker::Lorem.sentence(3)) } 

Author.all.each do |author|
  num = rand(0..3)
  num.times do
    prize = Prize.all.to_a.sample
    AuthorAward.create(author_id: author.id, prize_id: prize.id, year: rand(1900..2014))
  end
end