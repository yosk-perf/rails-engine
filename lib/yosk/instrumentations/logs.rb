module Yosk
  module Instrumentations
    class Logs
      def initialize(execution_id)
        @execution_id = execution_id
      end

      def enabled?
        true
      end

      def setup
        redis_logger = RedisLogger.new(@execution_id)
        Rails.logger = redis_logger

        if defined?(ActiveRecord)
          ActiveRecord::Base.logger = redis_logger
          ActiveRecord::Base.verbose_query_logs = true
          ActiveSupport::LogSubscriber.colorize_logging = false
        end
      end

      def before_request; end

      def after_request; end

      def teardown; end

      class RedisLogger < Logger
        attr_reader :execution_id

        def initialize(execution_id)
          @execution_id = execution_id
        end

        def info(message)
          message = { messagePayload: message }
          message['logLevel'] = 'info'

          write_to_redis(message)
        end

        def warn(message)
          message = { messagePayload: message }
          message['logLevel'] = 'warn'

          write_to_redis(message)
        end

        def error(message)
          message = { messagePayload: message }
          message['logLevel'] = 'error'

          write_to_redis(message)
        end

        def debug?
          true
        end

        def debug(message)
          message = { messagePayload: message }
          message['logLevel'] = 'debug'

          write_to_redis(message)
        end

        private

        def write_to_redis(message)
          message['id'] = SecureRandom.uuid
          message['timestamp'] = Time.now

          Yosk::Execution.append_list @execution_id, 'logs', message
        end
      end
    end
  end
end
