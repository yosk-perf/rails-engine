require 'memory_profiler'

def build_controller(execution_request)
  controller = execution_request['controller'].constantize.new
  controller.params = ActionController::Parameters.new(execution_request['params'].merge(action: execution_request['action']))
  controller.response = ActionDispatch::Response.new
  controller.request = ActionDispatch::TestRequest.create

  if execution_request['user_id'].present?
    controller.instance_variable_set :@current_user, User.find(execution_request['user_id'])
  end

  controller
end

INSTRUMENTATIONS = [
  Yosk::Instrumentations::ActiveRecordSqlQueries,
  Yosk::Instrumentations::Logs
].freeze

desc 'Explaining what the task does'
task :yosk, [:execution_id] => [:environment] do |_task, args|
  begin
    execution_context = Rails.application.executor.run!

    execution_request = Yosk::Execution.find_request(args.execution_id)

    instrumentations = INSTRUMENTATIONS.map { |klass| klass.new(args.execution_id) }.select(&:enabled?)
    runtime = Yosk::Instrumentations::Runtime.new(args.execution_id)

    instrumentations.each(&:setup)
    runtime.setup

    controller = build_controller execution_request

    instrumentations.each(&:before_request)

    report = MemoryProfiler.report(ignore_files: /yosk/) do
      runtime.before_request
      controller.send(execution_request['action'])
      runtime.after_request
    end

    instrumentations.each(&:after_request)

    execution_context.complete!

    Yosk::Execution.write_result args.execution_id, 'response', controller.response.body

    io = StringIO.new
    report.pretty_print(io)
    Yosk::Execution.write_result args.execution_id, 'memory', io.string

    runtime.teardown
    instrumentations.each(&:teardown)

    Yosk::Execution.complete! args.execution_id
  rescue StandardError => err
    Yosk::Execution.failed! args.execution_id, err
  end
end
