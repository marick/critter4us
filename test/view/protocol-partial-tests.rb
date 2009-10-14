$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ProtocolPartialTests < FreshDatabaseTestCase
  
  def setup
    @floating = Procedure.random(:name => 'floating')
    @filly = Animal.random(:name => 'filly', :kind => 'mare')
    @jake = Animal.random(:name => 'jake', :kind => 'gelding')
    @moo = Animal.random(:name => 'moo', :kind => 'cow')
    @billy = Animal.random(:name => 'billy', :kind => 'goat')
  end

  context "protocol used"  do

    should "be precise protocol if it's the only one" do
      existing_protocol = Protocol.random(:animal_kind => 'equine',
                                          :procedure => @floating)
      partial = ProtocolPartial.for(@floating, @filly)
      assert { partial.protocol == existing_protocol } 
    end

    should "be generic protocol if it's the only one" do
      existing_protocol = Protocol.random(:animal_kind => Protocol::CATCHALL_KIND,
                                          :procedure => @floating)
      partial = ProtocolPartial.for(@floating, @filly)
      assert { partial.protocol == existing_protocol } 
    end

    should "favor specific over generic" do
      generic_protocol = Protocol.random(:animal_kind => Protocol::CATCHALL_KIND,
                                          :procedure => @floating)
      specific_protocol = Protocol.random(:animal_kind => 'equine',
                                          :procedure => @floating)
      partial = ProtocolPartial.for(@floating, @filly)
      assert { partial.protocol == specific_protocol } 
    end

    should "use null protocol if no protocols match the procedure" do
      procedure_without_any_protocol = Procedure.random(:name => 'some procedure')
      partial = ProtocolPartial.for(procedure_without_any_protocol, @moo)
      assert { partial.protocol.is_a? Protocol::Null } 
    end

    should "use the null protocol if there's a different specific match and no generic" do
      wrong_specific_protocol = Protocol.random(:animal_kind => 'caprine',
                                                :procedure => @floating)
      partial = ProtocolPartial.for(@floating, @filly)
      assert { partial.protocol.is_a? Protocol::Null } 
    end

    should "use the generic protocol when no animal is given" do
      wrong_specific_protocol = Protocol.random(:animal_kind => 'caprine',
                                                :procedure => @floating)
      generic_protocol = Protocol.random(:animal_kind => Protocol::CATCHALL_KIND,
                                          :procedure => @floating)
      partial = ProtocolPartial.for(@floating)
      assert { partial.protocol == generic_protocol } 
    end

    should "use the null protocol when no animal is given and there is no generic" do
      wrong_specific_protocol = Protocol.random(:animal_kind => 'caprine',
                                                :procedure => @floating)
      partial = ProtocolPartial.for(@floating)
      assert { partial.protocol.is_a? Protocol::Null } 
    end
  end

  context "generic behavior" do

    setup do 
      @protocol = Protocol.create(:procedure => @floating, :animal_kind => 'equine',
                                  :description => "floating description")
      @partial = ProtocolPartial.for(@floating, @filly, @jake)
    end

    should "include an anchor/description combination" do 
      descriptions = []
      @partial.add_name_anchored_description(@protocol, descriptions)
      text = descriptions.first
      assert { text.include?(@partial.name_anchor(@protocol)) } 
      assert { text.include?(@protocol.description) } 
    end

    should "include a description only once" do 
      other_protocol = Protocol.random(:description => 'Lolz be uneek string')
      descriptions = []
      @partial.add_name_anchored_description(@protocol, descriptions)
      @partial.add_name_anchored_description(other_protocol, descriptions)
      @partial.add_name_anchored_description(@protocol, descriptions)
      assert { descriptions.length == 2 }
      assert { descriptions[0].include?(@protocol.description) }
      assert { descriptions[1].include?('Lolz be uneek string') }
    end
  end

  context "a procedure that has only a single protocol" do 

    setup do 
      @floating_protocol_equine = Protocol.create(:procedure => @floating, :animal_kind => 'equine',
                                                  :description => "floating description")
      @partial = ProtocolPartial.for(@floating, @filly, @jake)
    end

    should "be able to create a link from a procedure to its protocol" do
      text = @partial.linkified_procedure_name
      protocol_id = @floating_protocol_equine.unique_identifier
      assert_xhtml(text) do
        a("floating", :href => "##{protocol_id}")
      end
    end

    should "be able to create a link to same place if duplicate procedures" do
      first_version = ProtocolPartial.for(@floating, @filly).linkified_procedure_name.to_s
      second_version = ProtocolPartial.for(@floating, @jake).linkified_procedure_name.to_s
      assert { first_version == second_version }
    end

    should "have a destination whose tag name matches the link" do 
      descriptions = []
      @partial.add_name_anchored_descriptions_to(descriptions)
      protocol_names = extract_names(descriptions.first)
      procedure_hrefs = extract_hrefs(@partial.linkified_procedure_name)
      assert { procedure_hrefs == protocol_names } 
    end

    should "have a description anchored by the protocol name anchor" do
      descriptions = []
      @partial.add_name_anchored_descriptions_to(descriptions)
      text = descriptions.first
      assert_xhtml(text) do
        div(/floating description/) do 
          a(:name => /\d+/)
        end
      end
    end
  end

  context "a procedure that has multiple animal kinds" do 
    setup do 
      @floating_protocol_caprine = Protocol.create(:procedure => @floating,
                                                :animal_kind => 'caprine',
                                                :description => "floating description (goat)")
      @floating_protocol_bovine = Protocol.create(:procedure => @floating,
                                                :animal_kind => 'bovine',
                                                :description => "floating description (cow)")
    end

    should "be able to create a link from a procedure/animal to its protocol" do
      text = ProtocolPartial.for(@floating, @moo, @billy).linkified_procedure_name
      bovine_protocol_id = @floating_protocol_bovine.unique_identifier
      caprine_protocol_id = @floating_protocol_caprine.unique_identifier
      assert_xhtml(text) do
        span(/floating/) do
          a(/bovine/, :href => "##{bovine_protocol_id}")
          a(/caprine/, :href => "##{caprine_protocol_id}")
        end
      end
    end

    should "be able to create protocol descriptions for each protocol" do
      descriptions = []
      partial = ProtocolPartial.for(@floating, @moo, @billy)
      text = partial.add_name_anchored_descriptions_to(descriptions)
      assert { descriptions[0].include?(@floating_protocol_bovine.description) } 
      assert { descriptions[1].include?(@floating_protocol_caprine.description) } 
    end
  end

  def extract_hrefs(text)
    text.scan(/href=["']#(.*?)['"]/).flatten
  end

  def extract_names(text)
    text.scan(/name=["'](.*?)['"]/).flatten
  end
end
