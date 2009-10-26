
class Group < Sequel::Model
  many_to_one :reservation
  one_to_many :uses, :eager => [:animal, :procedure]

  def before_destroy
    uses.each { | use | use.destroy }
  end

  def in_wire_format
    { 
      'procedures' => collect_each_in_wire_format(:procedure),
      'animals' => collect_each_in_wire_format(:animal),
    }
  end

  def animals; identities(:animal); end
  def procedures; identities(:procedure); end
  def animal_names; names(:animal); end
  def procedure_names; names(:procedure); end

  private

  def names(attribute_name)
    uses.collect { | use | 
      use.send(attribute_name).name
    }.uniq.sort
  end

  def identities(attribute_name)
    uses.collect { | use | 
      use.send(attribute_name)
    }.uniq
  end

  def collect_each_in_wire_format(attribute)
    uses.collect { |use| use.send(attribute).in_wire_format }.uniq.sort
  end
      
end
