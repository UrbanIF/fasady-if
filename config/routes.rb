FasadyIf::Application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  put 'login_with_oauth', to: "oauth#index"

  namespace 'api' do
    resources :map_objects, only: [:index, :create] do
      collection do
        get 'categories', to: :categories
      end
    end
  end

  root :to => "home#index"
end
