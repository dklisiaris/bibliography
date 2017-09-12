FactoryGirl.define do
  factory :place do
    name "MyString"
role "MyString"
address "MyString"
telephone "MyString"
fax "MyString"
email "MyString"
website "MyString"
latitude 1.5
longitude 1.5
placeable_id 1
placeable_type "MyString"
  end

end

# == Schema Information
#
# Table name: places
#
#  id             :integer          not null, primary key
#  name           :string
#  role           :string
#  address        :string
#  telephone      :string
#  fax            :string
#  email          :string
#  website        :string
#  latitude       :decimal(10, 6)
#  longitude      :decimal(10, 6)
#  placeable_id   :integer
#  placeable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_places_on_placeable_id_and_placeable_type  (placeable_id,placeable_type)
#
