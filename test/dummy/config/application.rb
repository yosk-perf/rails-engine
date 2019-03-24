require_relative 'boot'

require 'rails'
require "action_controller/railtie"

Bundler.require(*Rails.groups)
require "yosk"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2


    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.eager_load_paths << "#{Rails.root}/lib"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

