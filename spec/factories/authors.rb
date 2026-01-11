FactoryBot.define do
  factory :author do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    extra_info { "#{Faker::Number.number(digits: 4)}-#{Faker::Number.number(digits: 4)}" }
    biography { Faker::Lorem.paragraph(sentence_count: 4) }
    image { Faker::Avatar.image(slug: "person-432", size: "160x208", format: "jpg") }
    biblionet_id { Faker::Number.number(digits: 4).to_i }

    factory :invalid_author do
      firstname { nil }
      lastname { nil }
    end
  end

end

# == Schema Information
#
# Table name: authors
#
#  id                  :integer          not null, primary key
#  firstname           :string
#  lastname            :string
#  extra_info          :string
#  biography           :text
#  image               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  biblionet_id        :integer
#  impressions_count   :integer          default(0)
#  slug                :string
#  tsearch_vector      :tsvector
#  contributions_count :integer          default(0)
#  uploaded_avatar     :string
#  masterpiece_id      :integer
#  middle_name         :string
#  born_year           :integer
#  death_year          :integer
#
# Indexes
#
#  authors_tsearch_idx              (tsearch_vector) USING gin
#  index_authors_on_biblionet_id    (biblionet_id) UNIQUE
#  index_authors_on_masterpiece_id  (masterpiece_id)
#  index_authors_on_slug            (slug) UNIQUE
#
