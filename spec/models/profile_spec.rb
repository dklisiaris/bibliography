require 'rails_helper'

RSpec.describe Profile, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
