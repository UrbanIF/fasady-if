class MapObject
  include Mongoid::Document


  field :name, type: String
  field :location, type: Array
  field :description, type: String
  field :before_photo, type: String
  field :after_photo, type: String
  field :reviewed, type: Mongoid::Boolean, default: false


  scope :active, where(reviewed: true)

  belongs_to :category
  belongs_to :user

  index({location: "2d"}, {min: -200, max: 200})

  embeds_one :address

  mount_uploader :before_photo, MapObjectPhotoUploader
  mount_uploader :after_photo, MapObjectPhotoUploader

  accepts_nested_attributes_for :address

end



