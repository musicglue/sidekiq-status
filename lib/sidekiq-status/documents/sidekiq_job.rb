require 'mongoid'

class SidekiqJob
  include Mongoid::Document

  identity type: String

  field :entity_id,   type: String
  field :status,      type: String
  field :message,     type: Hash
  field :updated_at,  type: Time, default: ->{ Time.now }

  index :entity_id

end
