class User::Google
  include Mongoid::Document
  embedded_in :user
end
