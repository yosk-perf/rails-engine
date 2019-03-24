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
          params: params.to_unsafe_h.fetch(:params, {})
      }

      execution_id = Yosk::Execution.start! execution_request


      command = "cd #{Rails.root} && bundle exec rake \"yosk[#{execution_id}]\""
      IO.popen(command)

      render json: {execution_id: execution_id}
    end

    def status
      render json: Yosk::Execution.status(params.require(:id))
    end

    def fetch_response
      render json: Yosk::Execution.fetch_response(params.require(:id), 'response')
    end

    def details
      render json: Yosk::Execution.fetch_response(params.require(:id), 'details')
    end

    def memory_profiler
      render plain: Yosk::Execution.fetch_response(params.require(:id), 'memory')
    end

    def logs
      render json: Yosk::Execution.fetch_logs(params.require(:id))
    end
  end
end
