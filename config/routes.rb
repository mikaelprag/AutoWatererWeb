Rails.application.routes.draw do
  root to: 'readings#index'
  resources :readings
  resources :notes
end
