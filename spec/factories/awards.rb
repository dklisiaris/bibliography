FactoryGirl.define do
  factory :award do
    prize nil
year 1
awardable_id 1
awardable_type "MyString"
  end

end

# == Schema Information
#
# Table name: awards
#
#  id             :integer          not null, primary key
#  prize_id       :integer
#  year           :integer
#  awardable_id   :integer
#  awardable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_awards_on_awardable_id_and_awardable_type  (awardable_id,awardable_type)
#  index_awards_on_prize_id                         (prize_id)
#
# Foreign Keys
#
#  fk_rails_...  (prize_id => prizes.id)
#
