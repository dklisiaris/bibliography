FactoryBot.define do
  factory :shelf do
    name { "MyString" }
    privacy { :same_as_profile }
    built_in { false }
    active { false }
    association :user
  end

end

# == Schema Information
#
# Table name: shelves
#
#  id           :integer          not null, primary key
#  name         :string
#  privacy      :integer          default("same_as_profile")
#  built_in     :boolean          default(FALSE)
#  default_name :integer          default("my_library")
#  active       :boolean          default(TRUE)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_shelves_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
