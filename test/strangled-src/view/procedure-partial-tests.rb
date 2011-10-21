require './test/testutil/requires'
require './strangled-src/model/requires'
require './strangled-src/view/requires'

class ProcedurePartialTests < FreshDatabaseTestCase
  include HtmlAssertions
  
  def setup
    @floating = Procedure.random(:name => 'floating')
    @venipuncture = Procedure.random(:name => 'venipuncture')
    @filly = Animal.random(:name => 'filly', :kind => 'mare', :procedure_description_kind => 'equine')
    @jake = Animal.random(:name => 'jake', :kind => 'gelding', :procedure_description_kind => 'equine')
    @moo = Animal.random(:name => 'moo', :kind => 'cow', :procedure_description_kind => 'bovine')
    @billy = Animal.random(:name => 'billy', :kind => 'goat', :procedure_description_kind => 'caprine')
  end

  context "procedure description used"  do

    should "be precise procedure description if it's the only one" do
      existing_procedure_description = ProcedureDescription.random(:animal_kind => 'equine',
                                          :procedure => @floating)
      partial = ProcedurePartial.for(@floating, @filly)
      assert { partial.procedure_description == existing_procedure_description } 
    end

    should "be generic procedure description if it's the only one" do
      existing_procedure_description = ProcedureDescription.random(:animal_kind => ProcedureDescription::CATCHALL_KIND,
                                          :procedure => @floating)
      partial = ProcedurePartial.for(@floating, @filly)
      assert { partial.procedure_description == existing_procedure_description } 
    end

    should "favor specific over generic" do
      generic_procedure_description = ProcedureDescription.random(:animal_kind => ProcedureDescription::CATCHALL_KIND,
                                          :procedure => @floating)
      specific_procedure_description = ProcedureDescription.random(:animal_kind => 'equine',
                                          :procedure => @floating)
      partial = ProcedurePartial.for(@floating, @filly)
      assert { partial.procedure_description == specific_procedure_description } 
    end

    should "use null procedure description if no descriptions match the procedure" do
      procedure_without_any_procedure_description = Procedure.random(:name => 'some procedure')
      partial = ProcedurePartial.for(procedure_without_any_procedure_description, @moo)
      assert { partial.procedure_description.is_a? ProcedureDescription::Null } 
    end

    should "use the null procedure description if there's a different specific match and no generic" do
      wrong_specific_procedure_description = ProcedureDescription.random(:animal_kind => 'caprine',
                                                :procedure => @floating)
      partial = ProcedurePartial.for(@floating, @filly)
      assert { partial.procedure_description.is_a? ProcedureDescription::Null } 
    end

    should "use the generic procedure description when no animal is given" do
      wrong_specific_procedure_description = ProcedureDescription.random(:animal_kind => 'caprine',
                                                :procedure => @floating)
      generic_procedure_description = ProcedureDescription.random(:animal_kind => ProcedureDescription::CATCHALL_KIND,
                                          :procedure => @floating)
      partial = ProcedurePartial.for(@floating)
      assert { partial.procedure_description == generic_procedure_description } 
    end

    should "use the null procedure description when no animal is given and there is no generic" do
      wrong_specific_procedure_description = ProcedureDescription.random(:animal_kind => 'caprine',
                                                :procedure => @floating)
      partial = ProcedurePartial.for(@floating)
      assert { partial.procedure_description.is_a? ProcedureDescription::Null } 
    end
  end

  context "generic behavior" do

    setup do 
      @procedure_description = ProcedureDescription.create(:procedure => @floating, :animal_kind => 'equine',
                                  :description => "floating description")
      @partial = ProcedurePartial.for(@floating, @filly, @jake)
    end

    should "include an anchor/description combination" do 
      descriptions = []
      @partial.add_name_anchored_description(@procedure_description, descriptions)
      text = descriptions.first
      assert { text.include?(@partial.name_anchor(@procedure_description)) } 
      assert { text.include?(@procedure_description.description) } 
    end

    should "include a description only once" do 
      other_procedure_description = ProcedureDescription.random(:description => 'Lolz be uneek string')
      descriptions = []
      @partial.add_name_anchored_description(@procedure_description, descriptions)
      @partial.add_name_anchored_description(other_procedure_description, descriptions)
      @partial.add_name_anchored_description(@procedure_description, descriptions)
      assert { descriptions.length == 2 }
      assert { descriptions[0].include?(@procedure_description.description) }
      assert { descriptions[1].include?('Lolz be uneek string') }
    end
  end

  context "a procedure that has only a single procedure description" do 

    setup do 
      @floating_procedure_description_equine = ProcedureDescription.create(:procedure => @floating, :animal_kind => 'equine',
                                                  :description => "floating description")
      @partial = ProcedurePartial.for(@floating, @filly, @jake)
    end

    should "be able to create a link from a procedure to its procedure description" do
      text = @partial.linkified_procedure_name
      procedure_description_id = @floating_procedure_description_equine.unique_identifier
      assert_text_has_selector(text, 'a', :text => "floating")
      assert_text_has_attributes(text, 'a', :href => "##{procedure_description_id}")
      # assert_xhtml(text) do
      #   a("floating", :href => "##{procedure_description_id}")
      # end
    end

    should "be able to create a link to same place if duplicate procedures" do
      first_version = ProcedurePartial.for(@floating, @filly).linkified_procedure_name.to_s
      second_version = ProcedurePartial.for(@floating, @jake).linkified_procedure_name.to_s
      assert { first_version == second_version }
    end

    should "have a destination whose tag name matches the link" do 
      descriptions = []
      @partial.add_name_anchored_descriptions_to(descriptions)
      procedure_description_names = extract_names(descriptions.first)
      procedure_hrefs = extract_hrefs(@partial.linkified_procedure_name)
      assert { procedure_hrefs == procedure_description_names } 
    end

    should "have a description anchored by the name anchor" do
      descriptions = []
      @partial.add_name_anchored_descriptions_to(descriptions)
      text = descriptions.first
      assert_text_has_selector(text, 'div', :text => /floating description/)
      assert_text_has_attributes(text, "a", :name =>  /\d+/)
      # assert_xhtml(text) do
      #   div(/floating description/) do 
      #     a(:name => /\d+/)
      #   end
      # end
    end

    should "include cases where there are two species but only a generic procedure description" do 
      @venipuncture_procedure_description = ProcedureDescription.create(:procedure => @venipuncture,
                                               :animal_kind => ProcedureDescription::CATCHALL_KIND,
                                               :description => "floating description (catchall")
      partial = ProcedurePartial.for(@venipuncture, @moo, @billy)
      procedure_name = partial.linkified_procedure_name
      procedure_description_id = @venipuncture_procedure_description.unique_identifier

      assert_text_has_selector(procedure_name, "a", :text => "venipuncture")
      assert_text_has_attributes(procedure_name, "a", :href => "##{procedure_description_id}")
      # assert_xhtml(procedure_name) do
      #   a("venipuncture", :href => "##{procedure_description_id}")
      # end

      descriptions = []
      partial.add_name_anchored_description(@venipuncture_procedure_description, descriptions)
      assert { 1 == descriptions.length }
    end

  end

  context "a procedure that has multiple animal kinds" do 
    setup do 
      @floating_procedure_description_caprine = ProcedureDescription.create(:procedure => @floating,
                                                :animal_kind => 'caprine',
                                                :description => "floating description (goat)")

      @floating_procedure_description_bovine = ProcedureDescription.create(:procedure => @floating,
                                                :animal_kind => 'bovine',
                                                :description => "floating description (cow)")
    end

    should "be able to create a link from a procedure/animal to its specific procedure description" do
      text = ProcedurePartial.for(@floating, @moo, @billy).linkified_procedure_name
      bovine_procedure_description_id = @floating_procedure_description_bovine.unique_identifier
      caprine_procedure_description_id = @floating_procedure_description_caprine.unique_identifier

      assert_text_has_selector(text, "span", :text=>/floating/)
      assert_text_has_selector(text, "a", :text=>/bovine/)
      assert_text_has_attributes(text, "a", :href => "##{bovine_procedure_description_id}")
      assert_text_has_selector(text, "a", :text=>/caprine/)
      assert_text_has_attributes(text, "a", :href => "##{caprine_procedure_description_id}")

      # assert_xhtml(text) do
      #   span(/floating/) do
      #     a(/bovine/, :href => "##{bovine_procedure_description_id}")
      #     a(/caprine/, :href => "##{caprine_procedure_description_id}")
      #   end
      # end
    end

    should "be able to create descriptions for each procedure" do
      descriptions = []
      partial = ProcedurePartial.for(@floating, @moo, @billy)
      text = partial.add_name_anchored_descriptions_to(descriptions)
      assert { descriptions[0].include?(@floating_procedure_description_bovine.description) } 
      assert { descriptions[1].include?(@floating_procedure_description_caprine.description) } 
    end
  end

  def extract_hrefs(text)
    text.scan(/href=["']#(.*?)['"]/).flatten
  end

  def extract_names(text)
    text.scan(/name=["'](.*?)['"]/).flatten
  end
end
