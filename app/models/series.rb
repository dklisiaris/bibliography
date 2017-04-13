class Series < ActiveRecord::Base
  validates :name, presence: true

  has_many :books

  after_validation :calculate_search_terms, :if => :name_changed?

  searchkick batch_size: 100,
  callbacks: :async,
  match: :word_start,
  searchable: [:tsearch_vector],
  word_start: [:tsearch_vector]

  def search_data
  {
    tsearch_vector: tsearch_vector.gsub("'", "").split(" "),
  }
  end

  def slugged_name(opts={})
    opts[:max_expansions] ||= 1
    opts[:dashes] = true if opts[:dashes].nil?
    join_with = opts[:dashes] ? '-' : ' '

    converter = Greeklish.converter(max_expansions: opts[:max_expansions], generate_greek_variants: false)
    name_to_slug = ApplicationController.helpers.detone(UnicodeUtils.downcase(name).gsub('ς','σ').gsub(/[,.:'·-]/,''))
    name_to_slug.split(" ").map do |word|
      converted = converter.convert(word)
      converted.present? ? converted : word
    end.flatten.uniq.join(join_with)
  end

  def calculate_search_terms
    write_attribute(:tsearch_vector, slugged_name(max_expansions: 3, dashes: false))
  end
end
