class Shelf < ActiveRecord::Base
  belongs_to :user

  has_many :bookshelves
  has_many :books, through: :bookshelves

  enum privacy: %i(Ίδια\ με\ το\ προφίλ Δημόσια Ιδιωτικη)
  enum default_name: ["Η βιβλιοθήκη μου", "Θέλω να διαβάσω", "Αγαπημένα", "Διαβάζω τώρα", "Εχω διαβάσει αλλά δεν έχω", "Για διάβασμα"]

  def screen_name
    return name if name.present? and not built_in?

    return default_name.humanize if built_in?
  end

end
