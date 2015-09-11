class Api::V1::SessionSerializer < ActiveModel::Serializer
  #just some basic attributes
  attributes :id, :email, :roles, :token

  def token
    object.api_key
  end

  def roles
    object.role_list
  end
end
