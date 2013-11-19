class CurrentUserSerializer < ActiveModel::Serializer
  attributes :name, :avatar
  has_one :twitter, :facebook
  has_many :map_objects
end
