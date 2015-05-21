class PlacePresenter < BasePresenter
  presents :place

  def address
    place_element(I18n.t('places.address'), place.address)
  end

  def telephone
    place_element(I18n.t('places.telephones'), place.telephone)
  end

  def fax
    place_element(I18n.t('places.fax'), place.fax)
  end

  def website
    place_element(I18n.t('places.website'), place.website)
  end

  def email
    place_element(I18n.t('places.email'), place.email)
  end

  def place_element(title, value) 
    if value.present?
      html = []
      html << h.content_tag(:strong, title)
      html << h.tag(:br)
      html << value.split(',').join(h.tag(:br))
      html << h.tag(:br)
      html.join.html_safe
    end
  end

end