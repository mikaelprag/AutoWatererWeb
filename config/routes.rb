Rails.application.routes.draw do
  root to: 'readings#index'
  resources :stations, controller: 'readings', action: 'index' do
    get 'latest', to: 'readings#latest'
  end
  resources :readings
  resources :notes
  get '/:id', to: 'readings#index'
end
