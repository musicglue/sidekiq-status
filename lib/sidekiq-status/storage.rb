module Sidekiq::Status::Storage
  RESERVED_FIELDS=%w(status stop update_time).freeze

  def for_entity(entity)
    SidekiqJob.find(@id).set(:entity_id, entity)
  end

  def update_message!(message)
    SidekiqJob.find(@id).set(:message, message)
    update_timestamps!
  end

  def update_status!(status)
    SidekiqJob.find(@id).set(:status, status)
    update_timestamps!
  end

  def job_document(uuid)
    SidekiqJob.find(uuid)
  end

  private

  def update_timestamps!
    SidekiqJob.find(@id).update_at(Time.now)
  end

end
