module Yosk
  module Instrumentations
    class Runtime
      def initialize(execution_id)
        @execution_id = execution_id

        @duration = nil
        @allocation_count_start = 0
        @allocation_count_finish = 0
      end

      def enabled?
        true
      end

      def setup; end

      def before_request
        @time = now
        @allocation_count_start = now_allocations
      end

      def after_request
        @end = now
        @allocation_count_finish = now_allocations

        results = {
          total_duration: 1000.0 * (@end - @time),
          allocations_count: @allocation_count_finish - @allocation_count_start
        }

        Yosk::Execution.write_result @execution_id, 'details', results.to_json
      end

      def teardown; end


      # Returns the difference in milliseconds between when the execution of the
      # event started and when it ended.
      #
      #   ActiveSupport::Notifications.subscribe('wait') do |*args|
      #     @event = ActiveSupport::Notifications::Event.new(*args)
      #   end
      #
      #   ActiveSupport::Notifications.instrument('wait') do
      #     sleep 1
      #   end
      #
      #   @event.duration # => 1000.138

      private

      def now
        Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end

      if defined?(JRUBY_VERSION)
        def now_allocations
          0
        end
      else
        def now_allocations
          GC.stat :total_allocated_objects
        end
      end
    end
  end
end
