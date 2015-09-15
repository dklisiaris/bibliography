class Api::V1::SessionSerializer < ActiveModel::Serializer
  #just some basic attributes
  attributes :id, :email, :username, :name, :roles, :token

  def token
    object.api_key
  end

  def roles
    object.role_list
  end

  def username
    object.profile.username
  end

  def name
    object.profile.name
  end
end
