Reminders::Application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'

  root to: 'sessions#new'
  resource :session, only: :destroy
  resources :spaces, only: :index do
    resources :reminders
  end
end
