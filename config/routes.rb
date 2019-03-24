Yosk::Engine.routes.draw do
  get 'routes', to: 'main#routes'

  resources :execution, only: [:create] do
    member do
      get :status
    end
  end
end
