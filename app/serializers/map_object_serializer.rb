class MapObjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :description, :value, :tokens, :category, :color, :letter,
  :before_photo, :after_photo
  has_one  :address

  has_many

  def id
    object.id.to_s
  end

  def category
    object.category.name if object.category
  end

  def color
    object.category.color if object.category
  end

  def letter
    object.address.street[0] if object.address
  end

  def before_photo
    object.before_photo.url
  end
  def after_photo
    object.after_photo.url
  end

  #for twitter typehead
  def value
    if object.address.modifier
      "#{object.address.prefix} #{object.address.street}, #{object.address.building_number} #{object.address.modifier} (#{object.name})"
    else
      "#{object.address.prefix} #{object.address.street}, #{object.address.building_number} (#{object.name})"
    end
  end


  def tokens
    object.address.street.split(/[\s,.-]+/)
    .push(object.address.building_number.to_s)
    .push(object.address.prefix)
    .push(object.name)
  end
end
