class User::Facebook
  include Mongoid::Document
  embedded_in :user

  field :access_token
  field :expires_in, type: DateTime

  field :user_name
  field :user_link
  field :uid

end
