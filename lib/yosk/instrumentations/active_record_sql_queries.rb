module Yosk
  module Instrumentations
    class ActiveRecordSqlQueries
      def initialize(execution_id)
        @execution_id = execution_id
      end

      def enabled?
        defined?(ActiveRecord)
      end

      def setup; end

      def before_request
        @subscriber = ::ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
          event = ActiveSupport::Notifications::Event.new *args

          next if event.payload.fetch(:sql) == 'COMMIT'
          next if event.payload.fetch(:sql) == 'SCHEMA'
          next if event.payload.fetch(:name) == 'SCHEMA'

          operation = {
            name: event.payload.fetch(:name),
            query: event.payload.fetch(:sql),
            duration: event.duration
          }

          Yosk::Execution.append_list @execution_id, 'sql_queries', operation
        end
      end

      def after_request; end

      def teardown
        if @subscriber
          ActiveSupport::Notifications.unsubscribe(@subscriber)
          @subscriber = nil
        end
      end
    end
  end
end
