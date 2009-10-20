module TestSupport
  # Allow tests to override particular attributes. Use like this:
  #
  # Mocks can be handed to procedure as hash. 
  #
  # def initialize(mocks = {})
  #   collaborators_start_as(:use_source => Use,
  #                          :procedure_source => Procedure,
  #                          :hash_maker => HashMaker.new).unless_overridden_by(mocks)
  # end
  #
  # Alternately, the collaborators can be overridden after initialization, which starts
  # by leaving off #unless_overridden_by:
  #
  # def initialize(*args)
  # super
  # collaborators_start_as(:animal_source => Animal, 
  #                        :procedure_source => Procedure,
  #                        :reservation_source => Reservation,
  #                        :timeslice => Timeslice.new)
  # end
  #
  # 
  # Then the caller can override like this:
  #
  #   @app.override(mocks(:timeslice, :animal_source, :procedure_source))
  # 
  # 

  def collaborators_start_as(default_hash)
    default_hash.each do | collaborator, default_value | 
      this_name = "@#{collaborator}"
      instance_variable_set(this_name, default_value)
      self.class.send(:attr_reader, collaborator)
    end
    self
  end

  def unless_overridden_by(mocks)
    mocks.each do | collaborator, mock | 
      this_name = "@#{collaborator}"
      instance_variable_set(this_name, mock)
    end
  end
  alias_method :override, :unless_overridden_by
end
