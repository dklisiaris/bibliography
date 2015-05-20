class Book < ActiveRecord::Base
  
  has_and_belongs_to_many :categories

  has_many :contributions
  has_many :authors, through: :contributions
  belongs_to :publisher
  has_many :awards, as: :awardable

  has_many  :writers, -> { where contributions: { job: 0 } },
            :through => :contributions,
            :class_name => "Author", 
            :source => :author

  has_many  :contributors, -> { where.not(contributions: { job: 0 }) },
            :through => :contributions,
            :class_name => "Author", 
            :source => :author            

  has_many :bookshelves
  has_many :shelves, through: :bookshelves

  enum availability: %i(Κυκλοφορεί Υπό\ Έκδοση Εξαντλημένο Κυκλοφορεί\ -\ Εκκρεμής\ εγγραφή Έχει\ αποσυρθεί\ από\ την\ κυκλοφορία)
  enum cover_type: %i(Μαλακό\ εξώφυλλο Σκληρό\ εξώφυλλο Spiral)
  enum format: %i(Βιβλίο CD-ROM CD-Audio Κασέτα Χάρτης Επιτραπέζιο\ παιχνίδι Κασέτα\ VHS Παιχνίδια-Κατασκευές DVD-ROM Video\ DVD Video\ CD e-book Άλλο )
  enum original_language: %i(αγγλικά αλβανικά αραβικά αρμενικά αρχαία\ ελληνικά αφρικάανς αϊτινά\ κρεολικά βασκικά βιετναμικά βουλγαρικά γίντις γαλλικά γερμανικά γερμανοεβραϊκά γεωργιανά δανέζικα εβραϊκά ελληνικά ελληνικά\ της\ βίβλου ελληνικά\ του\ βυζαντίου εσπεράντο θιβετιανά ιαπωνικά ινδικά ιρλανδικά ισλανδικά ισπανικά ιταλικά καταλανικά κινεζικά κοπτικά κορεατικά κουρδικά κροατικά λατινικά λιθουανικά νορβηγικά ολλανδικά ουγγρικά ουκρανικά περσικά πολωνικά πομακικά πορτογαλικά ρουμανικά ρωσικά σερβικά σερβο-κροατικά σερβοβοσνιακά σλαβομακεδονικά σλοβακικά σλοβενικά σουηδικά τουρκικά τσεχικά φινλανδικά φλαμανδικά)

  before_destroy do 
    categories.clear
    contributions.clear
    bookshelves.clear
    awards.clear
  end

  # Log impressions filtered by ip
  is_impressionable :counter_cache => true, :unique => true
  
  def main_author
    if collective_work?
      I18n.t('books.collective_work')
    else
      writers.first.fullname if writers.first.present? 
    end
  end


  # searchkick batch_size: 50, 
  # callbacks: :async, 
  # # text_middle: ['title', 'description'],
  # text_middle: ['title'],  
  # # word_start: ['title', 'description'],
  # autocomplete: ['title']

  def search_data
  {
    title: title,
    # description: short_description
  }
  end

  def short_description(max_chars=350)
    if description.present? and description.length<=max_chars
      description.html_safe
    elsif description.present? and description.length>max_chars
      (description[0...max_chars]+'...').html_safe
    else
      nil
    end
  end

  
  # Returns book cover url if there is one or the default not image.
  def cover
    if image.present?
      image      
    else
      "https://bookopolis.com/img/no_book_cover.jpg"
    end
  end

end

