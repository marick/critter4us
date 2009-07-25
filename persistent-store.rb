require 'config'

class PersistentStore
  def procedure_names
    DB[:procedures].map(:name).sort
  end
end
