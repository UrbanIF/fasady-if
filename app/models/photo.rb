class Photo
  include Mongoid::Document

  field :link, type: String
  #field :approved, type: Mongoid::Boolean, default: false

  belongs_to :user

  embedded_in :map_object, inverse_of: :before_photos
  embedded_in :map_object, inverse_of: :after_photos

  mount_uploader :link, MapObjectPhotoUploader

end
