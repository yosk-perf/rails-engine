require "yosk/configuration"
require "yosk/engine"
require "yosk/execution"
require "yosk/event_recorder"
require "yosk/sql_queries_recorder"

require "yosk/instrumentations/active_record_sql_queries"
require "yosk/instrumentations/runtime"
require "yosk/instrumentations/logs"

module Yosk
  def self.config
    yield(Yosk::Configuration)
  end
end
