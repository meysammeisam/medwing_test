# frozen_string_literal: true

# Redis Distributed Lock Manager
# https://redis.io/topics/distlock
module RedisDLM
  # RedisDLM::DLM
  module DLM
    def self.with_lock!(obj:, ttl: 2.minutes, lock_for: 'thermostat', &block)
      lock = RedisDLM::Lock.new(obj: obj, ttl: ttl, lock_for: lock_for)
      lock.lock!
      begin
        block.call(lock)
      ensure
        lock.unlock
      end
    end
  end
end
