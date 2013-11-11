FasadyIf::Application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  put 'login_with_socials/twitter', to: "oauth#twitter"
  put 'login_with_socials/facebook', to: "oauth#facebook"

  namespace 'api' do
    resources :map_objects, only: [:index, :create] do
      collection do
        get 'categories', to: :categories
      end
    end

    get 'user', to: "user#index"
  end

  root :to => "home#index"
end
