FactoryBot.define do
  factory :book do
    title { "MyString" }
    subtitle { "MyString" }
    description { "MyText" }
    image { "MyString" }
    isbn { "MyString" }
    isbn13 { "MyString" }
    ismn { "MyString" }
    issn { "MyString" }
    series { "MyString" }
    pages { 1 }
    publication_year { 1 }
    publication_place { "MyString" }
    price { "9.99" }
    price_updated_at { "2014-12-31" }
    physical_description { "MyString" }
    cover_type { 1 }
    availability { 1 }
    format { 1 }
    original_language { 1 }
    original_title { "MyString" }
    publisher { nil }
    extra { "MyString" }
    biblionet_id { 1 }
  end

end

# == Schema Information
#
# Table name: books
#
#  id                      :integer          not null, primary key
#  title                   :string
#  subtitle                :string
#  description             :text
#  image                   :string
#  isbn                    :string
#  isbn13                  :string
#  ismn                    :string
#  issn                    :string
#  series_name             :string
#  pages                   :integer
#  publication_year        :integer
#  publication_place       :string
#  price                   :decimal(6, 2)
#  price_updated_at        :date
#  size                    :string
#  cover_type              :integer          default("Μαλακό εξώφυλλο")
#  availability            :integer          default("Κυκλοφορεί")
#  format                  :integer          default("Βιβλίο")
#  original_language       :integer
#  original_title          :string
#  publisher_id            :integer
#  extra                   :string
#  biblionet_id            :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  collective_work         :boolean          default(FALSE)
#  series_volume           :integer
#  publication_version     :integer
#  impressions_count       :integer          default(0)
#  slug                    :string
#  language                :integer
#  tsearch_vector          :tsvector
#  series_id               :integer
#  liked_by_count_cache    :integer          default(0)
#  disliked_by_count_cache :integer          default(0)
#  bookshelves_count       :integer          default(0)
#  views_count             :integer          default(0)
#  uploaded_cover          :string
#  main_writer_id          :integer
#  first_publish_date      :date
#  current_publish_date    :date
#  future_publish_date     :date
#  genre_id                :bigint(8)
#
# Indexes
#
#  books_tsearch_idx              (tsearch_vector) USING gin
#  index_books_on_genre_id        (genre_id)
#  index_books_on_isbn            (isbn) UNIQUE
#  index_books_on_isbn13          (isbn13) UNIQUE
#  index_books_on_ismn            (ismn) UNIQUE
#  index_books_on_main_writer_id  (main_writer_id)
#  index_books_on_publisher_id    (publisher_id)
#  index_books_on_series_id       (series_id)
#  index_books_on_slug            (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (genre_id => genres.id)
#  fk_rails_...  (publisher_id => publishers.id)
#  fk_rails_...  (series_id => series.id)
#
