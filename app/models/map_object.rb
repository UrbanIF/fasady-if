class MapObject
  include Mongoid::Document


  field :name, type: String
  field :location, type: Array
  field :description, type: String

  belongs_to :category
  belongs_to :user

  index({location: "2d"}, {min: -200, max: 200})

  embeds_many :before_photos, class_name: 'Photo'
  embeds_many :after_photos,  class_name: 'Photo'

  embeds_one :address

  accepts_nested_attributes_for :before_photos, :after_photos, :address

end



