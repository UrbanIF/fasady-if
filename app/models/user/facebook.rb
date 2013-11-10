class User::Facebook
  include Mongoid::Document
  embedded_in :user

  field :access_token
  field :expires_in

  field :user_name
  field :user_link
  field :uid

end
