class RedisLogger

  attr_reader :execution_id

  def initialize(execution_id)
    @execution_id = execution_id
  end

  def info(message)
    message = {messagePayload: message}
    message["logLevel"] = "info"

    write_to_redis(message)
  end

  def warn(message)
    message = {messagePayload: message}
    message["logLevel"] = "warn"

    write_to_redis(message)
  end

  def error(message)
    message = {messagePayload: message}
    message["logLevel"] = "error"

    write_to_redis(message)
  end

  def debug?()
    true
  end

  def debug(message)
    message = {messagePayload: message}
    message["logLevel"] = "debug"

    write_to_redis(message)
  end

  private

  def write_to_redis(message)
    message["id"] = SecureRandom.uuid
    message["timestamp"] = Time.now

    Yosk::Execution.write_log @execution_id, message
  end
end
