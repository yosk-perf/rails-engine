require 'memory_profiler'

def build_controller(execution_request)
  controller = execution_request["controller"].constantize.new
  controller.params = ActionController::Parameters.new(execution_request["params"].merge(action: execution_request["action"]))
  controller.response = ActionDispatch::Response.new
  controller.request = ActionDispatch::TestRequest.create

  if execution_request["user_id"].present?
    controller.instance_variable_set :@current_user, User.find(execution_request["user_id"])
  end

  controller
end

INSTRUMENTATIONS = [
  Yosk::Instrumentations::ActiveRecordSqlQueries,
  Yosk::Instrumentations::Runtime,
  Yosk::Instrumentations::Logs,
]

desc 'Explaining what the task does'
task :yosk, [:execution_id] => [:environment] do |task, args|
  begin
    execution_request = Yosk::Execution.find_request(args.execution_id)

    instrumentations = INSTRUMENTATIONS.map { |klass| klass.new(args.execution_id) }.select(&:enabled?)

    instrumentations.each(&:setup)

    controller = build_controller execution_request

    execution_context = Rails.application.executor.run!

    instrumentations.each(&:before_request)

    report = MemoryProfiler.report {
      controller.send(execution_request["action"])
    }

    instrumentations.each(&:after_request)

    execution_context.complete!

    Yosk::Execution.write_result args.execution_id, 'response', controller.response.body

    io = StringIO.new
    report.pretty_print(io)
    Yosk::Execution.write_result args.execution_id, 'memory', io.string

    instrumentations.each(&:teardown)

    Yosk::Execution.complete! args.execution_id
  rescue StandardError => err
    Yosk::Execution.failed! args.execution_id, err
  end
end
