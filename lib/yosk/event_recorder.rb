# frozen_string_literal: true

class Yosk::EventRecorder
  attr_reader :time, :transaction_id, :payload, :children
  attr_accessor :end

  def initialize
    @children       = []
    @duration       = nil
    @cpu_time_start = nil
    @cpu_time_finish = nil
    @allocation_count_start = 0
    @allocation_count_finish = 0
  end

  def start!
    @time = now
    @cpu_time_start = now_cpu
    @allocation_count_start = now_allocations
  end

  def finish!
    @end = now
    @cpu_time_finish = now_cpu
    @allocation_count_finish = now_allocations
  end

  def cpu_time
    @cpu_time_finish - @cpu_time_start
  end

  def idle_time
    duration - cpu_time
  end

  def allocations
    @allocation_count_finish - @allocation_count_start
  end

  def results
    {
      total_duration: duration,
      allocations_count: allocations,
      instrumentation: $instrumenter.reset_runtime
    }
  end

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
  def duration
    @duration ||= 1000.0 * (self.end - time)
  end

  def <<(event)
    @children << event
  end

  def parent_of?(event)
    @children.include? event
  end

  private

  def now
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def now_cpu
    Process.clock_gettime(Process::CLOCK_PROCESS_CPUTIME_ID)
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
