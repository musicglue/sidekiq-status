require 'mongoid'

class SidekiqJob
  include Mongoid::Document

  identity type: String

  field :entity_id,   type: String
  field :status,      type: String
  field :message,     type: Hash
  field :updated_at,  type: Time, default: ->{ Time.now }

  index :entity_id

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
