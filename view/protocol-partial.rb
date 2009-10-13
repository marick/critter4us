class ProtocolPartial
  def initialize(procedure, *animals)
    @procedure = procedure
    @animals = animals
    @protocol = Protocol.protocols_for(@procedure).values[0]
  end

  def protocol_link
    "<a href='##{protocol_pk}'>#{@procedure.name}</a>"
  end

  def protocol_name_anchor
    "<a name='#{protocol_pk}'/>"
  end

  def protocol_pk
    return @protocol.pk if @protocol
    "no_protocol_defined"
  end

  def protocol_description
    description = if @protocol 
                    @protocol.description
                  else
                    "<b>#{@procedure.name}</b>: No protocol has yet been defined for this procedure."
                  end
    "<div>#{protocol_name_anchor}#{description}</div>"
  end
end
