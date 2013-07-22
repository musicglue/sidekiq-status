require 'mongoid'

class SidekiqJob
  include Mongoid::Document

  field :_id,         type: String
  field :entity_id,   type: String
  field :status,      type: String
  field :message,     type: Hash
  field :updated_at,  type: Time, default: ->{ Time.now }

  index entity_id: 1
  index status: 1
  index updated_at: 1

  def complete?
    status == 'complete'
  end

  def failed?
    status == 'failed'
  end

  def stoppped?
    status == 'stopped'
  end

  def working?
    status == 'working'
  end

  def queued?
    status == 'queued'
  end

end
