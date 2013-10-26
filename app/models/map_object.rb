class MapObject
  include Mongoid::Document


  field :name, type: String
  field :location, type: Array

  belongs_to :category
  belongs_to :user

  index({location: "2d"}, {min: -200, max: 200})

  embeds_many :before_photos, class_name: 'Photo'
  embeds_many :after_photos,  class_name: 'Photo'

  embeds_one :address

end

