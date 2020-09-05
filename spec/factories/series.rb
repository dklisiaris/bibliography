FactoryBot.define do
  factory :series do
    name { "MyString" }
    tsearch_vector { "" }
    books_count { 1 }
  end
end

# == Schema Information
#
# Table name: series
#
#  id             :integer          not null, primary key
#  name           :string
#  books_count    :integer          default(0)
#  tsearch_vector :tsvector
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
