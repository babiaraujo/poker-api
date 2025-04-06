Rails.application.routes.draw do
  get "game_results/index"
  get "game_results/show"
  get "/websocket_teste", to: "cable_test#index"  # <-- MOVA pra cá

  defaults format: :json do
    resources :rooms do
      member do
        post :join
        post :leave
        post :start
      end
    end

    resources :game_results, only: [ :index, :show ]

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
end
