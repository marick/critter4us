class ProtocolPartial
  private_class_method :new

  def self.for(procedure, *animals)
    distinct_animal_protocol_kinds_in_use = animals.collect { | animal | 
      animal.protocol_kind
    }.uniq.sort
    if distinct_animal_protocol_kinds_in_use.length > 1
      NProtocolPartial.new(procedure, distinct_animal_protocol_kinds_in_use)
    else
      OneProtocolPartial.new(procedure, distinct_animal_protocol_kinds_in_use.first)
    end
  end

  class OneProtocolPartial < ProtocolPartial
    public_class_method :new

    attr_reader :protocol  # for test

    def initialize(procedure, protocol_kind)
      @procedure = procedure
      protocol_hash = Protocol.protocols_for(@procedure)
      @protocol = protocol_hash[protocol_kind]
      @protocol = protocol_hash[Protocol::CATCHALL_KIND] unless @protocol
      @protocol = Protocol::Null.new(procedure, protocol_kind) unless @protocol
    end

    def protocol_link
      "<a href='##{@protocol.pk}'>#{@procedure.name}</a>"
    end

    def protocol_name_anchor
      "<a name='#{@protocol.pk}'/>"
    end

    def protocol_description
      "<div>#{protocol_name_anchor}#{@protocol.description}</div>"
    end
  end

  class NProtocolPartial < ProtocolPartial
    public_class_method :new

    def initialize(procedure, protocol_kinds)
      @procedure = procedure
      protocol_hash = Protocol.protocols_for(@procedure)
      protocols = protocol_kinds.collect { | kind | protocol_hash[kind] }
=begin
      @generator = if protocol_hash.empty?
                     NoProtocolGenerator.new(procedure)
                   elsif protocol_hash.length == 1
                     OneProtocolGenerator.new(protocol_hash.values[0])
                   else
                     OneProtocolGenerator.new(protocol_hash[protocol_kind])
                   end
=end
    end

  end




end
