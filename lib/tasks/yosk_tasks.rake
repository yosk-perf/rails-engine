require 'memory_profiler'

def build_controller(execution_request)
  controller = execution_request["controller"].constantize.new
  controller.params = ActionController::Parameters.new(execution_request["params"].merge(action: execution_request["action"]))
  controller.response = ActionDispatch::Response.new
  controller.request = ActionDispatch::TestRequest.create
  controller.instance_variable_set :@current_user, User.find(execution_request["user_id"])

  controller
end

desc 'Explaining what the task does'
task :yosk, [:execution_id] => [:environment] do |task, args|
  begin
    execution_request = Yosk::Execution.find_request(args.execution_id)

    redis_logger = RedisLogger.new(args.execution_id)

    Rails.logger = redis_logger
    ActiveRecord::Base.logger = redis_logger
    ActiveRecord::Base.verbose_query_logs = true
    ActiveSupport::LogSubscriber.colorize_logging = false

    # ActiveRecord::Base.establish_connection(:production_read_replica)

    controller = build_controller execution_request

    execution_context = Rails.application.executor.run!

    event_recorder = Yosk::EventRecorder.new
    event_recorder.start!

    queries_recorder = Yosk::SqlQueriesRecorder.new
    queries_recorder.start! args.execution_id

    report = MemoryProfiler.report {
      controller.send(execution_request["action"])
    }


    event_recorder.finish!
    queries_recorder.finish!
    execution_context.complete!

    Yosk::Execution.write_result args.execution_id, 'details', event_recorder.results.to_json
    Yosk::Execution.write_result args.execution_id, 'response', controller.response.body

    io = StringIO.new
    report.pretty_print(io)
    Yosk::Execution.write_result args.execution_id, 'memory', io.string

    Yosk::Execution.complete! args.execution_id
  rescue StandardError => err
    Yosk::Execution.failed! args.execution_id, err
  end
end
