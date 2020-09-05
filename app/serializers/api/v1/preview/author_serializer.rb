class Api::V1::Preview::AuthorSerializer < Api::V1::BaseSerializer
  attributes :id, :firstname, :lastname, :url, :site_url

  def attributes
    data = super
    data[:fullname] = fullname
    data[:image] = avatar
    data
  end

  def fullname
    return object.fullname
  end

  def avatar
    return object.avatar
  end

end
