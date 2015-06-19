class Api::V1::BaseSerializer < ActiveModel::Serializer
  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end

  def url
    url_for([:api,:v1, object])
  end  

  def site_url
    url_for(object)
  end
end