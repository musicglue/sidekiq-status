require "sidekiq-status/version"
require 'sidekiq-status/storage'
require 'sidekiq-status/worker'
require 'sidekiq-status/client_middleware'
require 'sidekiq-status/server_middleware'
require 'sidekiq-status/documents/sidekiq_job'
require 'sidekiq-status/removed_tracked_job'

module Sidekiq
  module Status
    extend Storage
    DEFAULT_EXPIRY = 60 * 30
    UUID_REGEXP = /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/

    # Job status by id
    # @param [String] id job id returned by async_perform
    # @return [String] job status, possible values: "queued" , "working" , "complete"
    def self.get(id)
      SidekiqJob.find(id)
    end
  end
end
