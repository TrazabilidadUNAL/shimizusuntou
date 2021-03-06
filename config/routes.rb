Rails.application.routes.draw do
  apipie

  get '/', to: redirect('/apidoc')
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
        resources :containers, only: [:index, :show]
        resources :products, only: [:index, :show]
        resources :packages
        resources :routes do
          resources :details, controller: 'route_logs'
        end
      end

      concern :user_crops do
        resources :crops do
          resources :logs, controller: 'crop_logs'
        end
      end

      resources :containers, only: [:index, :show]
      resources :products, only: [:index, :show]

      resource :producer, concerns: [:localizable, :user, :user_crops]
      resource :warehouse, concerns: [:localizable, :user]
    end
  end
end
