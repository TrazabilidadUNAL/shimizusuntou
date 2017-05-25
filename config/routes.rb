Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # API Definition
  scope module: 'api' do
    post '/sign-in', to: 'sessions#create'
    delete '/sign-out', to: 'sessions#destroy'

    namespace :v1 do
      concern :localizable do
        resources :places
      end

      concern :prod_products do
        resources :products, only: [:index]
      end
      concern :prod_routes do
        resources :routes, only: [:index]
      end
      concern :prod_packages do
        resources :packages, only: [:index]
      end

      resources :producers, except: [:index], concerns: [:localizable, :prod_products, :prod_routes, :prod_packages]
      resources :warehouses, except: [:index], concerns: :localizable
      resources :products
      resources :containers
      resources :crops
      resources :crop_logs
      resources :routes
      resources :route_logs
      resources :packages
    end
  end
end
