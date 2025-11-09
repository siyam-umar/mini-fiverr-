Rails.application.routes.draw do
  get 'messages/create'
  get 'conversations/index'
  get 'conversations/create'

  devise_for :users, sign_out_via: :delete

  root "services#index"
  get '/my_orders', to: 'orders#client_orders'
   get "/success", to: "payments#success"


  resources :conversations, only: [:index, :create, :show] do
    resources :messages, only: [:create, :destroy]
  end

  resources :services do
    resources :orders, only: [:create]
    resources :reviews, only: [:create]
  end

  resources :orders do
     post :create_checkout_session, on: :member
      resources :submissions, only: [:new, :create]
    member do
      patch :accept
      patch :reject
      patch :complete
      patch :update_status 
    end
  end
   post "/create_checkout_session", to: "payments#create_checkout_session"
   get "/success", to: "payments#success"
   get "/cancel", to: "payments#cancel"

  get "dashboard/client", to: "dashboards#client", as: "client_dashboard"
  get "dashboard/freelancer", to: "dashboards#freelancer", as: "freelancer_dashboard"
end



