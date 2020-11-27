class Api::V1::SessionSerializer < ActiveModel::Serializer
  #just some basic attributes
  attributes :id, :email, :username, :name, :role, :token

  def token
    object.api_key
  end

  def role
    object.role
  end

  def username
    object.profile.username
  end

  def name
    object.profile.name
  end
end
