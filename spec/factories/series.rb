FactoryGirl.define do
  factory :series do
    name "MyString"
    tsearch_vector ""
    books_count 1
  end
end
