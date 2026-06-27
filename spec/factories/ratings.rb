FactoryBot.define do
  factory :rating do
    association :user
    association :rateable, factory: :book
    rate { :like }
  end
end
