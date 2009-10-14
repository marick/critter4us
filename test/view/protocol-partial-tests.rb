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

  context "single protocol kind of animal" do 

    setup do 
      @floating_protocol_equine = Protocol.create(:procedure => @floating, :animal_kind => 'equine',
                                                  :description => "floating description")
      @partial = ProtocolPartial.for(@floating, @filly, @jake)
    end

    should "be able to create a link from a procedure to its protocol" do
      text = @partial.protocol_link
      protocol_id = @floating_protocol_equine.id
      assert_xhtml(text) do
        a("floating", :href => "##{protocol_id}")
      end
    end

    should "be able to create a link to same place if duplicate procedures" do
      first_version = ProtocolPartial.for(@floating, @filly).protocol_link.to_s
      second_version = ProtocolPartial.for(@floating, @jake).protocol_link.to_s
      assert { first_version == second_version }
    end

    should "be able to create the destination for the link" do
      text = @partial.protocol_name_anchor
      protocol_id = @floating_protocol_equine.id
      assert_xhtml(text) do
        a(:name => protocol_id.to_s)
      end
    end

    should "have a destination whose tag matches the link" do 
      assert { local_destination(@partial) == local_link(@partial) }
    end

    should "have a description anchored by the protocol name anchor" do
      text = @partial.protocol_description
      assert_xhtml(text) do
        div(/floating description/) do 
          a(:name => /\d+/)
        end
      end
    end

    should_eventually "have only one description no matter how many links" do
      text = @partial.protocol_description
      assert_xhtml(text) do
        div(/floating description/) do 
          a(:name => /\d+/)
        end
      end
    end
  end

  context "multiple protocols because multiple animal types" do 
    setup do 
      @floating_protocol_caprine = Protocol.create(:procedure => @floating,
                                                :animal_kind => 'caprine',
                                                :description => "floating description (goat)")
      @floating_protocol_bovine = Protocol.create(:procedure => @floating,
                                                :animal_kind => 'bovine',
                                                :description => "floating description (cow)")
    end

    should_eventually "be able to create a link from a procedure/animal to its protocol" do
      text = ProtocolPartial.for(@floating, @moo, @billy).protocol_link
      bovine_protocol_id = @floating_protocol_bovine.id
      caprine_protocol_id = @floating_protocol_caprine.id
      assert_xhtml(text) do
        td("floating") do
          a("bovine", :href => "##{bovine_protocol_id}")
          a("bovine", :href => "##{caprine_protocol_id}")
        end
      end
    end
  end

  def local_destination(partial)
    %r{name=["'](.*)['"]} =~ partial.protocol_name_anchor
    $1
  end

  def local_link(partial)
    %r{href=["']#(.*)['"]} =~ partial.protocol_link
    $1
  end

end
