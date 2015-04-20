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
  enum original_language: %i(Αγγλικά Αλβανικά Αραβικά Αρμενικά Αρχαία\ Ελληνικά Αφρικάανς Αϊτινά\ Κρεολικά Βασκικά Βιετναμικά Βουλγαρικά Γίντις Γαλλικά Γερμανικά Γερμανοεβραϊκά Γεωργιανά Δανέζικα Εβραϊκά Ελληνικά Ελληνικά\ Της\ Βίβλου Ελληνικά\ Του\ Βυζαντίου Εσπεράντο Θιβετιανά Ιαπωνικά Ινδικά Ιρλανδικά Ισλανδικά Ισπανικά Ιταλικά Καταλανικά Κινεζικά Κοπτικά Κορεατικά Κουρδικά Κροατικά Λατινικά Λιθουανικά Νορβηγικά Ολλανδικά Ουγγρικά Ουκρανικά Περσικά Πολωνικά Πομακικά Πορτογαλικά Ρουμανικά Ρωσικά Σερβικά Σερβο-κροατικά Σερβοβοσνιακά Σλαβομακεδονικά Σλοβακικά Σλοβενικά Σουηδικά Τουρκικά Τσεχικά Φινλανδικά Φλαμανδικά)

  before_destroy do 
    categories.clear
    contributions.clear
    bookshelves.clear
    awards.clear
  end

  def main_author
    if collective_work?
      I18n.t('books.collective_work')
    else
      writers.first.fullname if writers.first.present? 
    end
  end


  searchkick batch_size: 50, 
  callbacks: :async, 
  text_middle: ['title', 'description'],
  # word_start: ['title', 'description'],
  autocomplete: ['title']

  def search_data
  {
    title: title,
    description: short_description
  }
  end

  def short_description
    if description.present? and description.length<=10000
      description
    elsif description.present? and description.length>10000
      description[0...10000]
    else
      nil
    end
  end

end

