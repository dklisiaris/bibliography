FactoryBot.define do
  factory :prize do
    name { "MyString" }
  end

end

# == Schema Information
#
# Table name: prizes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_prizes_on_name  (name) UNIQUE
#
