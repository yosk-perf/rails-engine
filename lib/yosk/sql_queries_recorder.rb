class Yosk::SqlQueriesRecorder
  def start!(execution_id)
    finish!
    @subscriber = ::ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
      _, start, finish, _, payload = *args
      event = ActiveSupport::Notifications::Event.new *args

      next if payload.fetch(:sql) == 'COMMIT'
      next if payload.fetch(:sql) == 'SCHEMA'
      next if payload.fetch(:name) == 'SCHEMA'

      operation = {
        name: payload.fetch(:name),
        query: payload.fetch(:sql),
        duration: event.duration
      }

      Yosk::Execution.append_list execution_id, 'sql_queries', operation
    end

    self
  end

  def finish!
    if @subscriber
      ActiveSupport::Notifications.unsubscribe(@subscriber)
      @subscriber = nil
    end

    self
  end
end
