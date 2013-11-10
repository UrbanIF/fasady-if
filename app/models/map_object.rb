class MapObject
  include Mongoid::Document


  field :name, type: String
  field :location, type: Array
  field :description, type: String

  belongs_to :category
  belongs_to :user

  index({location: "2d"}, {min: -200, max: 200})

  embeds_one :address

  mount_uploader :before_photo, MapObjectPhotoUploader
  mount_uploader :after_photo, MapObjectPhotoUploader

  accepts_nested_attributes_for :address

end



