desc 'Explaining what the task does'
task :yosk, [:execution_id] => [:environment] do |task, args|
  begin
    execution_request = Yosk::Execution.find_request(args.execution_id)

    Rails.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.establish_connection(:production_read_replica)

    controller = execution_request["controller"].constantize.new
    controller.params = ActionController::Parameters.new(execution_request["params"].merge(action: execution_request["action"]))
    controller.response = ActionDispatch::Response.new
    controller.request = ActionDispatch::TestRequest.create
    controller.instance_variable_set :@current_user, User.find(execution_request["user_id"])

    execution_context = Rails.application.executor.run!

    controller.send(execution_request["action"])

    execution_context.complete!

    Yosk::Execution.complete! args.execution_id
    Yosk::Execution.write_result args.execution_id, 'response', controller.response.body
  rescue StandardError => err
  end
end
