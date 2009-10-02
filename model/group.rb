require 'config'

class Group < Sequel::Model
  many_to_one :reservation
  one_to_many :uses

  def before_destroy
    uses.each { | use | use.destroy }
  end

  def in_wire_format
    collect_each(:procedure)
    collect_each(:animal)
    { 
      'procedures' => collect_each(:procedure),
      'animals' => collect_each(:animal),
    }
  end

  def animal_names
    names(:animal)
  end

  def procedure_names
    names(:procedure)
  end

  private

  def names(attribute_name)
    uses.collect { | use | 
      use.send(attribute_name).name
    }.uniq.sort
  end

  def collect_each(attribute)
    uses.collect { |use| use.send(attribute).in_wire_format }.uniq.sort
  end
      
end
