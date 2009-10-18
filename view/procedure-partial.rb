class ProcedurePartial
  private_class_method :new

  def self.for(procedure, *animals)
    distinct_animal_procedure_description_kinds_in_use = animals.collect { | animal | 
      animal.procedure_description_kind
    }.uniq.sort
    procedure_descriptions = distinct_animal_procedure_description_kinds_in_use.collect { | kind | 
      procedure_description_for(procedure, kind) 
    }.uniq
    case procedure_descriptions.length
      when 0
        OneProcedurePartial.new(procedure, procedure_description_for(procedure, nil))
      when 1
        OneProcedurePartial.new(procedure, procedure_descriptions.first)
      else
        NProcedurePartial.new(procedure, procedure_descriptions)
    end
  end

  def self.procedure_description_for(procedure, procedure_description_kind)
    procedure_description_hash = ProcedureDescription.descriptions_for(procedure)
    procedure_description = procedure_description_hash[procedure_description_kind]
    procedure_description = procedure_description_hash[ProcedureDescription::CATCHALL_KIND] unless procedure_description
    procedure_description = ProcedureDescription::Null.new(procedure, procedure_description_kind) unless procedure_description
    procedure_description
  end

  def name_anchor(procedure_description)
    "<a name='#{procedure_description.unique_identifier}'/>"
  end

  def name_anchored_description(procedure_description)
    "<div>#{name_anchor(procedure_description)}#{procedure_description.description}</div>"
  end

  def add_name_anchored_description(procedure_description, so_far)
    description = name_anchored_description(procedure_description)
    so_far << description unless so_far.include?(description) 
  end


  class OneProcedurePartial < ProcedurePartial
    public_class_method :new

    attr_reader :procedure_description  # for test

    def initialize(procedure, procedure_description)
      @procedure = procedure
      @procedure_description = procedure_description
    end

    def linkified_procedure_name
      "<a href='##{@procedure_description.unique_identifier}'>#{@procedure.name}</a>"
    end

    def add_name_anchored_descriptions_to(so_far)
      add_name_anchored_description(@procedure_description, so_far)
    end
  end

  class NProcedurePartial < ProcedurePartial
    include Erector::Mixin
    public_class_method :new

    attr_reader :procedure, :procedure_descriptions

    def initialize(procedure, procedure_descriptions)
      @procedure = procedure
      @procedure_descriptions = procedure_descriptions
    end

    def linkified_procedure_name
      erector(:prettyprint => true) do
        span do
          text procedure.name
          procedure_descriptions.each do | procedure_description |
            rawtext "&nbsp;"
            a("(#{procedure_description.animal_kind})", :href => "##{procedure_description.unique_identifier}")
          end
        end
      end
    end

    def add_name_anchored_descriptions_to(so_far)
      @procedure_descriptions.each do | procedure_description | 
        add_name_anchored_description(procedure_description, so_far)
      end
    end

  end




end
