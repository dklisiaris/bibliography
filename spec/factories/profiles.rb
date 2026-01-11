FactoryBot.define do
  factory :profile do
    sequence(:username) { |n| "user#{n}" }
    name { "MyString" }
    avatar { "MyString" }
    about_me { "MyText" }
    about_library { "MyText" }
    account_type { :"Προσωπικός" }
    privacy { :is_public }
    language { :"Ελληνικά" }
    allow_comments { false }
    allow_friends { false }
    email_privacy { :"Ποτέ" }
    discoverable_by_email { false }
    receive_newsletters { false }
    association :user
  end

end

# == Schema Information
#
# Table name: profiles
#
#  id                    :integer          not null, primary key
#  username              :string
#  name                  :string
#  avatar                :string
#  cover                 :string
#  about_me              :text
#  about_library         :text
#  account_type          :integer          default("Προσωπικός")
#  privacy               :integer          default("is_public")
#  language              :integer          default("Ελληνικά")
#  allow_comments        :boolean          default(TRUE)
#  allow_friends         :boolean          default(TRUE)
#  email_privacy         :integer          default("Ποτέ")
#  discoverable_by_email :boolean          default(TRUE)
#  receive_newsletters   :boolean          default(TRUE)
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  social                :hstore
#  gender                :integer
#  city                  :string
#  birthday              :datetime
#
# Indexes
#
#  index_profiles_on_user_id   (user_id)
#  index_profiles_on_username  (username) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
