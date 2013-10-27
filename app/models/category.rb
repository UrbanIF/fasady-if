class Category
  include Mongoid::Document

  field :name, type: String
  field :color, type: String

  has_many :map_objects

end
