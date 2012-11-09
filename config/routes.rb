Reminders::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'

  root to: 'sessions#new'

  resources :spaces, only: :index do
    resources :reminders
  end
end
