class Address
  include Mongoid::Document

  field :prefix, type: String
  field :street, type: String
  field :building_number, type: Integer
  field :modifier, type: String

  embedded_in :map_object

  #todo ADD index

end
