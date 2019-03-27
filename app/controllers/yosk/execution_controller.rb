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
      pid = spawn(command)
      Process.detach pid

      render json: {execution_id: execution_id}
    end

    def fetch_request
      render json: Yosk::Execution.find_request(params.require(:id))
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
      render json: Yosk::Execution.fetch_list(params.require(:id), "logs")
    end

    def sql_queries
      render json: Yosk::Execution.fetch_list(params.require(:id), "sql_queries")
    end
  end
end
