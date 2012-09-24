require 'mongoid'

class SidekiqJob
  include Mongoid::Document

  identity type: String

  field :entity_id, type: String
  field :status,    type: String
  field :message,   type: Hash

  index :entity_id

end
