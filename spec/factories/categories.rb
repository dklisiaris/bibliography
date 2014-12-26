FactoryGirl.define do
  factory :category do
    name {Faker::Lorem.sentence}
    ddc {Faker::Number.number(3)}
    slug {Faker::Internet.slug(Faker::Lorem.sentence, '-')}
    biblionet_id {Faker::Number.number(4).to_i}
    parent_id nil

    factory :invalid_category do
      name nil
    end

  end
  
end
