require 'sidekiq'

module Sidekiq::Status
  class RemoveTrackedJob
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform job_id
      SidekiqJob.find(job_id).destroy
    end

  end
end
