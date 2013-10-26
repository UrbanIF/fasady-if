class Category
  include Mongoid::Document

  field :name, type: String

  has_many :map_objects

end
