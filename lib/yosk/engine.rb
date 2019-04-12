module Yosk
  class Engine < ::Rails::Engine
    isolate_namespace Yosk

    initializer 'static assets' do |app|
      app.middleware.use ScopedActionDispatchStatic, "#{root}/client/build", headers: {
        'Cache-Control' => 'immutable'
      }
    end

    initializer 'after_initialize' do
      Yosk.config do |cfg|
        # TODO: remove once we add config block on main app
        cfg.redis = $redis if defined?($redis)
      end
    end
  end
end
