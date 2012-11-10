Reminders::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'

  root to: 'sessions#new'
  resource :session, only: :destroy
  resources :spaces, only: :index do
    resources :reminders
  end
  resources :reminder_notifications, only: :create
end
