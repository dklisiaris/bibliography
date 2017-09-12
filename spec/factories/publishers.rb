FactoryGirl.define do
  factory :publisher do
    name "MyString"
owner "MyString"
  end

end

# == Schema Information
#
# Table name: publishers
#
#  id                :integer          not null, primary key
#  name              :string
#  owner             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  biblionet_id      :integer
#  impressions_count :integer          default(0)
#  slug              :string
#  tsearch_vector    :tsvector
#  books_count       :integer          default(0)
#
# Indexes
#
#  index_publishers_on_slug  (slug) UNIQUE
#  publishers_tsearch_idx    (tsearch_vector)
#
