class Address
  include Mongoid::Document

  field :prefix, type: String, default: ''
  field :street, type: String
  field :building_number, type: String
  # field :modifier, type: String

  embedded_in :map_object

  #todo ADD index
  validates_presence_of :street, :building_number

end
