Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
   controllers: {
     sessions: 'users/sessions',
     registrations: 'users/egistrations'
   }

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show]

      namespace :admin do
        resources :products, only: [:create, :show, :update, :destroy]
      end
    end
  end
end
