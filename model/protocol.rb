require 'pp'

class Protocol < Sequel::Model
  many_to_one :procedure

  def self.for(hash)
    procedure = hash[:procedure]
    raise "No procedure for #{hash.inspect}" unless procedure
    Protocol.filter(:procedure_id => hash[:procedure].id).first
  end

  # following are for testing

  def self.random(overrides = {})
    defaults = {
      :animal_kind => 'bovine',
      :procedure => Procedure.random,
      :description => 'some protocol description'
    }
    create(defaults.merge(overrides));
  end
end



