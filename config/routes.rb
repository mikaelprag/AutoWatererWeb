Rails.application.routes.draw do
  root to: 'readings#index'
  resources :stations, controller: 'readings', action: 'index'
  resources :readings
  resources :notes
  get '/:id', to: 'readings#index'
end
