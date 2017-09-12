require 'rails_helper'

RSpec.describe Shelf, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
