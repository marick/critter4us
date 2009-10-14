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

  def protocol_for(procedure, protocol_kind)
    protocol_hash = Protocol.protocols_for(procedure)
    protocol = protocol_hash[protocol_kind]
    protocol = protocol_hash[Protocol::CATCHALL_KIND] unless protocol
    protocol = Protocol::Null.new(procedure, protocol_kind) unless protocol
    protocol
  end

  def name_anchor(protocol)
    "<a name='#{protocol.unique_identifier}'/>"
  end

  def name_anchored_description(protocol)
    "<div>#{name_anchor(protocol)}#{protocol.description}</div>"
  end

  def add_name_anchored_description(protocol, so_far)
    description = name_anchored_description(protocol)
    so_far << description unless so_far.include?(description) 
  end


  class OneProtocolPartial < ProtocolPartial
    public_class_method :new

    attr_reader :protocol  # for test

    def initialize(procedure, protocol_kind)
      @procedure = procedure
      @protocol = protocol_for(procedure, protocol_kind)
    end

    def linkified_procedure_name
      "<a href='##{@protocol.unique_identifier}'>#{@procedure.name}</a>"
    end

    def add_name_anchored_descriptions_to(so_far)
      add_name_anchored_description(@protocol, so_far)
    end
  end

  class NProtocolPartial < ProtocolPartial
    include Erector::Mixin
    public_class_method :new

    attr_reader :procedure, :protocols

    def initialize(procedure, protocol_kinds)
      @procedure = procedure
      @protocols = protocol_kinds.collect { | kind | protocol_for(procedure, kind) }
    end

    def linkified_procedure_name
      erector(:prettyprint => true) do
        span do
          text procedure.name
          protocols.each do | protocol |
            rawtext "&nbsp;"
            a("(#{protocol.animal_kind})", :href => "##{protocol.unique_identifier}")
          end
        end
      end
    end

    def add_name_anchored_descriptions_to(so_far)
      @protocols.each do | protocol | 
        add_name_anchored_description(protocol, so_far)
      end
    end

  end




end
