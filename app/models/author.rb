class Author < ActiveRecord::Base
  validates :lastname, presence: true

  has_many :contributions
  has_many :books, through: :contributions
  has_many :awards, as: :awardable
  has_many :prizes, through: :awards  

  enum job: %i(Συγγραφέας Μεταφραστής Ερμηνευτής Εικονογράφος Φωτογράφος Επιμελητής Συνθέτης Στιχουργός Εισηγητής Διασκευαστής Ανθολόγος Φορέας Οργανισμός Υπεύθυνος\ Σειράς Υπεύθυνος\ Υποσειράς Αφηγητής Ζωγράφος Γλύπτης Καλλιτέχνης)

  # Log impressions filtered by ip
  is_impressionable :counter_cache => true, :unique => true

  def fullname
    return [firstname, lastname].join(' ') if firstname.present?
    return lastname
  end

  def fullname_reversed
    return [lastname, firstname].join(', ') if firstname.present?
    return lastname
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
  
end
