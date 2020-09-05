FactoryBot.define do
  factory :category do
    name {Faker::Lorem.sentence}
    ddc {Faker::Number.number(3)}
    slug {Faker::Internet.slug(Faker::Lorem.sentence, '-')}
    biblionet_id {Faker::Number.number(4).to_i}
    parent_id nil

    factory :invalid_category do
      name nil
    end

  end

end

# == Schema Information
#
# Table name: categories
#
#  id                :integer          not null, primary key
#  name              :string
#  ddc               :string
#  slug              :string
#  biblionet_id      :integer
#  parent_id         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  impressions_count :integer          default(0)
#  featured          :boolean          default(FALSE)
#  tsearch_vector    :tsvector
#
# Indexes
#
#  categories_tsearch_idx         (tsearch_vector) USING gin
#  index_categories_on_parent_id  (parent_id)
#  index_categories_on_slug       (slug) UNIQUE
#
