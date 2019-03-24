require_dependency "yosk/application_controller"

module Yosk
  class MainController < ApplicationController
    def routes
      render json: { success: true }
    end
  end
end
