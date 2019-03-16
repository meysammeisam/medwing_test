Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :thermostats, defaults: { format: 'json' }, only: [] do
        member do
          get :stats
        end
      end

      resources :readings, defaults: { format: 'json' }, only: %i[show create]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
