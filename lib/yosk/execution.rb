class Yosk::Execution
  def self.start!(request)
    id = SecureRandom.uuid

    $redis.set "yosk:execution:#{id}:request", request.to_json
    $redis.set "yosk:execution:#{id}:status", { status: 'in-progress' }.to_json

    id
  end

  def self.complete!(id)
    $redis.set "yosk:execution:#{id}:status", { status: 'completed' }.to_json
  end

  def self.failed!(id, error)
    $redis.set "yosk:execution:#{id}:status", { status: 'failed', error_message: error.message }.to_json
  end

  def self.write_result(id, type, body)
    $redis.set "yosk:execution:#{id}:response:#{type}", body
  end

  def self.fetch_response(id, type)
    $redis.get "yosk:execution:#{id}:response:#{type}"
  end

  def self.find_request(id)
    request = $redis.get "yosk:execution:#{id}:request"
    JSON.parse request
  end

  def self.status(id)
    $redis.get "yosk:execution:#{id}:status"
  end

  def self.append_list(id, type, message)
    return if message.empty?

    $redis.sadd "yosk:execution:#{id}:#{type}", message.to_json
  end

  def self.fetch_list(id, type)
    logs = $redis.smembers "yosk:execution:#{id}:#{type}"

    logs.map { |log| JSON.parse log }
  end
end
