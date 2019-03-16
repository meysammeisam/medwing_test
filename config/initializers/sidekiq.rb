# frozen_string_literal: true

require 'sidekiq'

module Sidekiq
  # Sidekiq::Logging
  module Logging
    # override existing log to include the arguments passed to `perform`
    def self.job_hash_context(job_hash)
      klass = job_hash['wrapped'] || job_hash['class']
      bid = job_hash['bid']
      args = job_hash['args']
      "#{klass} ARGS-#{args} JID-#{job_hash['jid']} BID-#{bid}"
    end
  end
end

Encoding.default_external = Encoding::UTF_8

Sidekiq.configure_server do |config|
  config.redis = { url:  Rails.application.secrets.sidekiq[:redis_uri] }
end

Sidekiq.configure_client do |config|
  config.redis = { url:  Rails.application.secrets.sidekiq[:redis_uri] }
  config.client_middleware do |chain|
    # Add sidekiq middlewares here
  end
end
