class MapObjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :value, :tokens, :category, :color, :letter
  has_one  :address

  has_many  :before_photos, :after_photos

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
    .push(object.location.to_s)
  end
end
