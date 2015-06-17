class Author < ActiveRecord::Base
  validates :lastname, presence: true

  has_many :contributions
  has_many :books, through: :contributions
  has_many :awards, as: :awardable
  has_many :prizes, through: :awards  

  enum job: %i(Συγγραφέας Μεταφραστής Ερμηνευτής Εικονογράφος Φωτογράφος Επιμελητής Συνθέτης Στιχουργός Εισηγητής Διασκευαστής Ανθολόγος Φορέας Οργανισμός Υπεύθυνος\ Σειράς Υπεύθυνος\ Υποσειράς Αφηγητής Ζωγράφος Γλύπτης Καλλιτέχνης Κειμενογράφος)

  # Log impressions filtered by ip
  is_impressionable :counter_cache => true, :unique => true

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  include PgSearch
  pg_search_scope :search_by_name, 
    :against => [
      [:lastname, 'A'],
      [:firstname, 'B'],
      [:tsearch_vector, 'C']
    ], 
    :using => {
      :tsearch => {:prefix => true, :tsvector_column => :tsearch_vector},
      :trigram => {:threshold => 0.15}
    }, 
    :ignoring => :accents

  multisearchable :against => [:lastname, :firstname, :tsearch_vector]    

  after_validation :calculate_search_terms, :if => :name_changed? 

  def fullname
    return [firstname, lastname].join(' ') if firstname.present?
    return lastname
  end

  def fullname_reversed
    return [lastname, firstname].join(', ') if firstname.present?
    return lastname
  end

  def name_changed?
    :lastname_changed? || :firstname_changed?
  end  

  def short_biography(max_chars=350)
    if biography.present? and biography.length<=max_chars
      biography.html_safe
    elsif biography.present? and biography.length>max_chars
      (biography[0...max_chars]+'...').html_safe
    else
      nil
    end
  end

  def avatar
    if image.present?
      image      
    else
      "http://ingermanson.com/images/no_profile_image.jpg"
    end        
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :slugged_name,
      [:slugged_name, :id],
    ]
  end  

  def slugged_name(opts={})
    opts[:max_expansions] ||= 1
    opts[:dashes] = true if opts[:dashes].nil?
    join_with = opts[:dashes] ? '-' : ' '

    converter = Greeklish.converter(max_expansions: opts[:max_expansions], generate_greek_variants: false)     
    name_to_slug = ApplicationController.helpers.detone(UnicodeUtils.downcase(fullname).gsub('ς','σ').gsub(/[,.:'·-]/,''))
    name_to_slug.split(" ").map do |word|
      converted = converter.convert(word)
      converted.present? ? converted : word
    end.flatten.uniq.join(join_with)
  end 

  def calculate_search_terms
    write_attribute(:tsearch_vector, slugged_name(max_expansions: 3, dashes: false))    
  end

  def associated_dates
    years_re = /\d+-\d*/
    return extra_info.split(',').select{|part| part =~ years_re}.join.strip if extra_info.present?
    nil
  end

  def associated_titles
    years_re = /\d+-\d*/
    return extra_info.split(',').reject{|part| part =~ years_re}.join(',').strip if extra_info.present?
    nil
  end  
  
end
