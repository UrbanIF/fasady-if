class CategorySerializer < ActiveModel::Serializer
  attributes :name, :id, :color

  def id
    object.id.to_s
  end

end
