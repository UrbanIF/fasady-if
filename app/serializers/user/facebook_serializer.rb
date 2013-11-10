class User::FacebookSerializer < ActiveModel::Serializer
  attributes :user_name, :user_link
end