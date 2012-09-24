module Sidekiq::Status::Storage
  RESERVED_FIELDS=%w(status stop update_time).freeze

  def for_entity(entity)
    SidekiqJob.find(@id).set(:entity_id, entity)
  end

  def update_message!(message)
    SidekiqJob.find(@id).set(:message, message)
  end

  def update_status!(status)
    SidekiqJob.find(@id).set(:status, status)
  end

  def job_document(uuid)
    SidekiqJob.find(uuid)
  end

end
