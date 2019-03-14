Reminders::Application.routes.draw do
  #root 'welcome#show'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'

  root to: 'sessions#new'
  resource :session, only: :destroy
  resources :spaces, only: :index do
    resources :reminders
  end
end
