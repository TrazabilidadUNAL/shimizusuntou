Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # API Definition
  scope module: 'api' do
    post '/sign-in', to: 'sessions#create'
    delete '/sign-out', to: 'sessions#destroy'
    get ':qrhash', to: 'v1/tracers#show'

    namespace :v1 do
      concern :localizable do
        resources :places
      end

      concern :user do
        resources :products
        resources :routes
        resources :containers
        resources :packages
      end

      concern :user_crops do
        resources :crops
      end

      resource :producer, concerns: [:localizable, :user]
      resource :warehouse, concerns: [:localizable, :user, :user_crops]

      resources :packages
    end
  end
end
