
class Group < Sequel::Model
  many_to_one :reservation
  one_to_many :uses

  def before_destroy
    uses.each { | use | use.destroy }
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
end
