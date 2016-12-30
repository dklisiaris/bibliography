class Shelf < ActiveRecord::Base
  belongs_to :user

  has_many :bookshelves
  has_many :books, through: :bookshelves

  enum privacy: %i(Ίδια\ με\ το\ προφίλ Δημόσια Ιδιωτικη)
  enum default_name: %i(my_library want_to_read favourites currently_reading read_but_not_own to_read)

  def screen_name
    return name if name.present? and not built_in?

    return I18n.t('shelves.' + default_name) if built_in?
  end

end
