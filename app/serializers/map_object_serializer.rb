class MapObjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :value, :tokens, :category
  has_one  :address

  has_many  :before_photos, :after_photos

  def id
    object.id.to_s
  end

  def category
    object.category.name
  end

  #for twitter typehead
  def value
    if object.address.modifier
      "#{object.address.street}, #{object.address.building_number} #{object.address.modifier} (#{object.name})"
    else
      "#{object.address.street}, #{object.address.building_number} (#{object.name})"
    end
  end

  def tokens
    [object.address.street, object.address.building_number, object.name]
  end
end
