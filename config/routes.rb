Yosk::Engine.routes.draw do
  get 'routes', to: 'main#routes'

  resources :execution, only: [:create] do
    member do
      get :status
      get :response, to: 'execution#fetch_response'
      get :details
      get :memory_profiler
      get :logs
    end
  end
end
