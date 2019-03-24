module Yosk
  class Engine < ::Rails::Engine
    isolate_namespace Yosk

    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
  end
end
