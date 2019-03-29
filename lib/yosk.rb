require "yosk/configuration"
require "yosk/engine"
require "yosk/execution"
require "yosk/event_recorder"
require "yosk/sql_queries_recorder"

module Yosk
  def self.config
    yield(Yosk::Configuration)
  end
end
