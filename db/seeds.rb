
require 'faker'

admin_user = User.create(:email => 'admin@bibliography.gr', :password => '12345678', :password_confirmation => '12345678') 
admin_user.editor!
admin_user.admin!

editor_user = User.create(:email => 'editor@bibliography.gr', :password => '12345678', :password_confirmation => '12345678') 
editor_user.editor!

100.times do 
  u = User.create(:email => Faker::Internet.email, :password => '12345678', :password_confirmation => '12345678') 
  u.create_profile(name: Faker::Name.name, username: Faker::Internet.user_name, avatar: Faker::Avatar.image, about_me: Faker::Lorem.sentences(3).join, about_library: Faker::Lorem.sentences(3).join)
end

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

Book.all.each do |book|
  rand(1..5).times do
    book.categories << categories.sample
  end
end

books = Book.all.to_a

Category.all.each do |category|
  rand(1..3).times do
    category.books << books.sample
  end
end

Author.all.each do |author|
  author.contributions.create(job: rand(0..18), book: books.sample) 
end 


authors = Author.all.to_a

Book.all.each do |book|
  book.contributions.create(job: 0, author: authors.sample)
  rand(2..5).times do
    book.contributions.create(job: rand(0..18), author: authors.sample) 
  end
end
