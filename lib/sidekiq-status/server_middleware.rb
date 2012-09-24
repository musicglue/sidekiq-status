module Sidekiq::Status
# Should be in the server middleware chain
  class ServerMiddleware
    # Parameterized initialization, use it when adding middleware to server chain
    # chain.add Sidekiq::Status::ServerMiddleware, :expiration => 60 * 5
    # @param [Hash] opts middleware initialization options
    # @option opts [Fixnum] :expiration ttl for complete jobs
    def initialize(opts = {:expiration => 30 * 60})
      @expiration = opts[:expiration]
    end

    # Takes out the first job argument to use as id
    # puts :working status into Redis hash
    # initializes worker instance with id
    #
    # Exception handler sets :failed status, re-inserts worker it to job args and re-throws the exception
    # Worker::Stopped exception type are processed separately - :stopped status is set, no re-throwing
    #
    # @param [Worker] worker worker instance, processed here if its class includes Status::Worker
    # @param [Array] msg job args, first of them used as job id, should have uuid format
    # @param [String] queue queue name
    def call(worker, msg, queue)
      if worker.class.ancestors.include? Sidekiq::Status::Worker
        worker.id = msg['args'].shift
        unless worker.id.is_a?(String) && UUID_REGEXP.match(worker.id)
          raise ArgumentError, "First job argument for a #{worker.class.name} should have uuid format"
        end
        worker.update_status! 'working'
        yield
        worker.update_status! 'complete'
      else
        yield
      end
    rescue Worker::Stopped
      worker.update_status! 'stopped'
    rescue => e
      if worker.class.ancestors.include? Sidekiq::Status::Worker
        worker.update_status! 'failed'
        worker.update_message!({
          exception: e.message,
          backtrace: e.backtrace,
          })
        msg['args'].unshift worker.id
      end
      raise
    ensure
      if worker.class.ancestors.include? Sidekiq::Status::Worker
        Sidekiq.redis { |conn| conn.expire worker.id, @expiration }
        Sidekiq::Status::RemoveTrackedJob.perform_in 1.minute, worker.id
      end
    end
  end
end
