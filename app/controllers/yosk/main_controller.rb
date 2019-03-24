require_dependency 'yosk/application_controller'

module Yosk
  class MainController < ApplicationController
    def routes
      render json: controllers
    end

    private 

    def controllers
      @@controllers ||= begin
        routes = Rails.application.routes.routes.map(&:defaults)

        controllers = routes.map { |c| c[:controller] }.uniq.compact

        controllers.map! do |controller|
          controller = "#{controller.camelize}Controller".safe_constantize
          next if controller.nil?

          actions = controller.action_methods.to_a
          file = controller.instance_method(actions.first.to_sym).source_location[0]

          next unless file.include? Rails.root.join('app').to_s

          {
            controller: controller.name,
            actions: actions
          }
        end

        controllers.compact!
                        end
    end
  end
end
