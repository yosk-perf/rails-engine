class ScopedActionDispatchStatic < ::ActionDispatch::Static
  def call(env)
    req = Rack::Request.new env

    if (req.get? || req.head?) && req.path_info.start_with?(/^\/?yosk\/static/)
      env['PATH_INFO'] = req.path_info.gsub(/^\/?yosk/, "")
    end

    super(env)
  end
end
