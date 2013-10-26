class AddressSerializer < ActiveModel::Serializer
  attributes :street, :building_number, :modifier
end
