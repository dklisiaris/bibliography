FactoryGirl.define do
  factory :author do
    firstname {Faker::Name.first_name}
    lastname {Faker::Name.last_name}
    lifetime {"#{Faker::Number.number(4)}-#{Faker::Number.number(4)}"}
    biography {Faker::Lorem.paragraph(4)}
    image {Faker::Avatar.image("person-432", "160x208", "jpg")}
    biblionet_id {Faker::Number.number(4).to_i}

    factory :invalid_author do
      firstname nil
      lastname nil
    end    
  end

end
