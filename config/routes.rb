Rails.application.routes.draw do
  defaults format: :json do
    resources :rooms do
      member do
        post :join
        post :leave
        post :start
      end
    end

    resources :players
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
