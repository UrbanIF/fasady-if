FasadyIf::Application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  namespace 'api' do
    resources :map_objects, only: [:index] do
      collection do
        get 'categories', to: :categories
      end
    end
  end

  root :to => "home#index"
end
