FactoryGirl.define do
  factory :profile do
    username "MyString"
name "MyString"
avatar "MyString"
about_me "MyText"
about_library "MyText"
account_type 1
privacy 1
language 1
allow_comments false
allow_friends false
email_privacy 1
discoverable_by_email false
receive_newsletters false
user nil
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
#  account_type          :integer          default(0)
#  privacy               :integer          default(0)
#  language              :integer          default(0)
#  allow_comments        :boolean          default(TRUE)
#  allow_friends         :boolean          default(TRUE)
#  email_privacy         :integer          default(0)
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
