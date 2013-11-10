class User::Twitter
  include Mongoid::Document
  embedded_in :user

  field :oauth_token
  field :oauth_token_secret

  field :user_name
  field :user_link
  field :uid

end
