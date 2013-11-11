class UserSerializer < ActiveModel::Serializer
  attributes :name, :avatar
  has_one :twitter, :facebook
end
