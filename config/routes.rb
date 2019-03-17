# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      get get 'thermostat/stats' => 'thermostats#stats', defaults: { format: :json }
      resources :readings, defaults: { format: 'json' }, only: %i[show create]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
