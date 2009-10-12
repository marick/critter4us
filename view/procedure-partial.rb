class ProcedurePartial
  def initialize(procedure)
    @procedure = procedure
  end

  def protocol_link
    "<a href='##{@procedure.pk}'>#{@procedure.name}</a>"
  end

  def protocol_name_anchor
    "<a name='##{@procedure.pk}'/>"
  end

end
