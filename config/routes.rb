Rails.application.routes.draw do
  resources :agents do
    resources :events, only: [:index, :new, :create, :destroy]
  end

  resources :dispositions
  root 'agents#index'
end
