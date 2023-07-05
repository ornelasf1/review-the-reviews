redis_host = Rails.application.secrets.redis && Rails.application.secrets.redis['host'] || 'localhost'
redis_port = Rails.application.secrets.redis && Rails.application.secrets.redis['port'] || 6379
disable_cache = ENV.fetch("DISABLE_CACHE") { false }

if ENV.fetch("RAILS_ENV") != "test" and not disable_cache
    # The constant below will represent ONE connection, present globally in models, controllers, views etc for the instance. No need to do Redis.new everytime
    begin
        REDIS = Redis.new(host: redis_host, port: redis_port.to_i)
        puts "Initialized Redis instance. Connected: #{REDIS.info.present?}"
    rescue => exception
        puts "Failed to connect to Redis instance: #{exception.message}"
        REDIS = nil
    end
else
    REDIS = nil
end