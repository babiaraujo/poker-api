Rails.application.routes.draw do
  get "websocket_test/index"
  defaults format: :json do
    resources :rooms do
      member do
        post :join
        post :leave
        post :start
      end
    end

    resources :players

    post "/evaluate_hand", to: "evaluations#evaluate_hand"

    resources :games do
      post :next_phase, on: :member
      post :action, on: :member
      post :finish, on: :member
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  mount ActionCable.server => "/cable"

  get "/websocket_teste", to: "websocket_test#index"
end
