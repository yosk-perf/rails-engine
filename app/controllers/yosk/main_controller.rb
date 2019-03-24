require_dependency "yosk/application_controller"

module Yosk
  class MainController < ApplicationController
    def routes
      routes = Rails.application.routes.routes.map { |x| x.defaults }

      routes.map! do |route|
        next if route[:controller].nil?
        {
          controller: "#{route[:controller].classify}Controller",
          action: route[:action]
        }
      end

      routes.compact!
      routes = routes.group_by { |r| r[:controller] }.map do |controller_name, controller_actions|
        {
          controller: controller_name,
          actions:  controller_actions.map { |a| a[:action] }
        }
      end

      render json: routes
    end
  end
end
