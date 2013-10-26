class PhotoSerializer < ActiveModel::Serializer
  attributes :url, :approved

  def url
    object.link.url
  end
end
