require 'config'

class PersistentStore
  def procedure_names
    DB[:procedures].map(:name)
  end

  def all_animals
    DB[:animals].map(:name)
  end
end
