module Yosk
  class Engine < ::Rails::Engine
    isolate_namespace Yosk

    initializer 'static assets' do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

    initializer 'after_initialize' do
      # TODO: remove once we add config block on main app
      Yosk::Configuraiton.redis = $redis if defined?($redis)
    end
  end
end
