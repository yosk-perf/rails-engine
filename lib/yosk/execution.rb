class Yosk::Execution

  def self.start!(request)
    id = SecureRandom.uuid

    $redis.set "yosk:execution:#{id}:request", request.to_json
    $redis.set "yosk:execution:#{id}:status", { status: "in-progress" }.to_json

    id
  end

  def self.find_request(id)
    request = $redis.get "yosk:execution:#{id}:request"
    JSON.parse request
  end

  def self.status(id)
    $redis.get "yosk:execution:#{id}:status"
  end
end
