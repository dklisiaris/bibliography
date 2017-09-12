FactoryGirl.define do
  factory :shelf do
    name "MyString"
privacy 1
built_in false
active false
user nil
  end

end

# == Schema Information
#
# Table name: shelves
#
#  id           :integer          not null, primary key
#  name         :string
#  privacy      :integer          default(0)
#  built_in     :boolean          default(FALSE)
#  default_name :integer          default(0)
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
