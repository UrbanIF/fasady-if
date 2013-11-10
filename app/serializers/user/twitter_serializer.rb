class User::TwitterSerializer < ActiveModel::Serializer
  attributes :user_name, :user_link
end
