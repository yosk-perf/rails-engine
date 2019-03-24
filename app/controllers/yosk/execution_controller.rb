require_dependency "yosk/application_controller"

module Yosk
  class ExecutionController < ApplicationController
    def create
      params.require(:request_controller)
      params.require(:request_action)
      params.require(:user_id)

      execution_request = {
        controller: params[:request_controller],
        action: params[:request_action],
        user_id: params[:user_id],
        params: params.to_unsafe_h[:params]
      }

      execution_id = Yosk::Execution.start! execution_request

      render json: { execution_id: execution_id }
    end

    def status
      render json: Yosk::Execution.status(params.require(:id))
    end
  end
end
