Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # API Definition
  scope module: 'api' do
    namespace :v1 do
      concern :localizable do
        resources :places
      end

      resources :producers, except: [:index], concerns: :localizable
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
