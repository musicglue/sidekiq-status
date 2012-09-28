require "active_support"

module Sidekiq::Status::Worker
  include Sidekiq::Status::Storage
  extend ActiveSupport::Concern

  # Adding ID generation to .perform_async
  module ClassMethods
    # :nodoc:
    def self.extended(base)
      class << base
        alias_method_chain :perform_async, :uuid
      end
    end

    # Add an id to job arguments
    def perform_async_with_uuid(*args)
      id = SecureRandom.uuid
      args.unshift id
      perform_async_without_uuid(*args)
      SidekiqJob.create(status: :queued)
    end
  end

  class Stopped < StandardError
  end

  attr_reader :id

  # Worker id initialization
  # @param [String] id id generated on client-side
  # @raise [RuntimeError] raised in case of second id initialization attempt
  # @return [String] id
  def id=(id)
    raise RuntimeError("Worker ID is already set : #@id") if @id
    @id=id
  end

  def status_document
    SidekiqJob.find(id)
  end

end
