class Yosk::Execution
  TTL = 1.hours
  def self.start!(request)
    id = SecureRandom.uuid

    Yosk::Configuration.redis.setex "yosk:execution:#{id}:request", TTL, request.to_json
    Yosk::Configuration.redis.setex "yosk:execution:#{id}:status", TTL, { status: 'in-progress' }.to_json

    id
  end

  def self.complete!(id)
    Yosk::Configuration.redis.setex "yosk:execution:#{id}:status", TTL, { status: 'completed' }.to_json
  end

  def self.failed!(id, error)
    Yosk::Configuration.redis.setex "yosk:execution:#{id}:status", TTL, { status: 'failed', error_message: error.message }.to_json
  end

  def self.write_result(id, type, body)
    Yosk::Configuration.redis.setex "yosk:execution:#{id}:response:#{type}", TTL, body
  end

  def self.fetch_response(id, type)
    Yosk::Configuration.redis.get "yosk:execution:#{id}:response:#{type}"
  end

  def self.find_request(id)
    request = Yosk::Configuration.redis.get "yosk:execution:#{id}:request"
    JSON.parse request
  end

  def self.status(id)
    Yosk::Configuration.redis.get "yosk:execution:#{id}:status"
  end

  def self.append_list(id, type, message)
    return if message.empty?

    Yosk::Configuration.redis.sadd "yosk:execution:#{id}:#{type}", message.to_json
  end

  def self.fetch_list(id, type)
    logs = Yosk::Configuration.redis.smembers "yosk:execution:#{id}:#{type}"

    logs.map { |log| JSON.parse log }
  end
end
