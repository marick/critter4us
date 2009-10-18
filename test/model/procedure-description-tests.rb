$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ProcedureDescriptionTests < FreshDatabaseTestCase

  context "class" do
    setup do
      @floating = Procedure.random(:name => 'floating')
    end

    should "be able to return appropriate description when no specialization" do
      procedure_description = ProcedureDescription.random(:procedure => @floating, :animal_kind => 'all')
      expected = { 'all' => procedure_description }
      actual = ProcedureDescription.procedure_descriptions_for(@floating)
      assert { actual == expected }
    end


    should "be able to return appropriate descriptions when per-animal specialization" do
      bovine = ProcedureDescription.random(:procedure => @floating, :animal_kind => 'bovine',
                               :description => 'bovine floating')
      caprine = ProcedureDescription.random(:procedure => @floating, :animal_kind => 'caprine',
                                :description => 'caprine floating')
      expected = { 'caprine' => caprine, 'bovine' => bovine }
      actual = ProcedureDescription.procedure_descriptions_for(@floating)
      assert { actual == expected }
    end
  end
end

class NullProcedureDescriptionTests < FreshDatabaseTestCase


  def setup
    @floating = Procedure.random(:name => 'floating')
    super
  end

  context "a legitimate animal kind" do 
    setup do
      @null_procedure_description = ProcedureDescription::Null.new(@floating, 'bovine')
    end

    should "have an id that's distinct yet stable from instance to instance" do
      assert { @null_procedure_description.unique_identifier == "no_procedure_description_defined_for_#{@floating.pk}_and_bovine" }
    end


    should "return a description" do
      assert { /floating/ =~ @null_procedure_description.description }
      assert { /bovine/ =~ @null_procedure_description.description }
      assert { /description.*has not/ =~ @null_procedure_description.description }
    end
  end

  context "no animal kind" do 
    setup do
      @null_procedure_description = ProcedureDescription::Null.new(@floating, nil)
    end

    should "be suitably vague when asked the animal kind" do 
      assert { @null_procedure_description.animal_kind == 'any species' } 
    end

    should "have an id that's distinct yet stable from instance to instance" do
      assert { @null_procedure_description.unique_identifier == "no_procedure_description_defined_for_#{@floating.pk}_and_any_species" }
    end

    should "return a description" do
      expected = /floating/
      assert { /floating/ =~ @null_procedure_description.description }
      assert { /any species/ =~ @null_procedure_description.description }
      assert { /description.*has not/ =~ @null_procedure_description.description }
    end
  end

end
