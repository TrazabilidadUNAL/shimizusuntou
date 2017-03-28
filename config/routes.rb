Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # API Definition
  scope module: 'api' do
    namespace :v1 do
      resources :products
      resources :containers
      resources :places
      resources :producers
      resources :crops
      resources :crop_logs
      resources :routes
      resources :warehouses
      resources :route_logs
    end
  end
end
