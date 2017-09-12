require 'rails_helper'

RSpec.describe Place, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
