class AddressSerializer < ActiveModel::Serializer
  attributes :prefix, :street, :building_number #, :modifier
end
