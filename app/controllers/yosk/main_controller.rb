require_dependency 'yosk/application_controller'

module Yosk
  class MainController < ApplicationController
    def routes
      routes = Rails.application.routes.routes.map(&:defaults)

      routes.map! do |route|
        next if route[:controller].nil?

        controller = "#{route[:controller].camelize}Controller".safe_constantize
        next if controller.nil?

        actions = controller.action_methods.to_a
        file = controller.instance_method(actions.first.to_sym).source_location[0]

        next unless file.include? Rails.root.join('app').to_s

        {
          controller: controller.name,
          actions: actions
        }
      end

      routes.compact!

      render json: routes
    end
  end
end
