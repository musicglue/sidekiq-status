module Sidekiq::Status::Storage
  RESERVED_FIELDS=%w(status stop update_time).freeze

  def for_entity(entity)
    job = SidekiqJob.find(@id)
    return if job.nil?
    job.set(entity_id: entity)
  end

  def update_message!(message)
    message = { :text => message } if message.is_a? String
    job = SidekiqJob.find(@id)
    return if job.nil?
    job.set(message: message)
    update_timestamps!
  end

  def update_status!(status)
    job = SidekiqJob.find(@id)
    return if job.nil?
    job.set(status: status)
    update_timestamps!
  end

  def job_document(uuid)
    SidekiqJob.find(uuid)
  end

  private

  def update_timestamps!
    job = SidekiqJob.find(@id)
    return if job.nil?
    job.set(updated_at: Time.now)
  end

end
