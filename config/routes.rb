class StaticResponder
  attr_accessor :path

  def initialize(path)
    self.path = path
    trigger_file_handler_initialization
  end

  def trigger_file_handler_initialization
    file_handler
  end

  def call(env)
    env['PATH_INFO'] = @file_handler.match?(path)
    @file_handler.call(env)
  end

  def inspect
    "static('#{path}')"
  end

  def file_handler
    @file_handler ||= ::ActionDispatch::FileHandler.new(
      Yosk::Engine.root.join('client').join('build').to_s
    )
  end
end

Yosk::Engine.routes.draw do
  get 'routes', to: 'main#routes'

  get '/', to: StaticResponder.new('index.html')
  get '/:id', to: StaticResponder.new('index.html')

  resources :execution, only: [:create] do
    member do
      get :status
      get :request, to: 'execution#fetch_request'
      get :response, to: 'execution#fetch_response'
      get :details
      get :memory_profiler
      get :logs
      get :sql_queries
    end
  end
end
