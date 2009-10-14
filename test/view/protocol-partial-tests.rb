$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ProtocolPartialTests < FreshDatabaseTestCase
  
  def setup
    @floating = Procedure.random(:name => 'floating')
    @betsy = Animal.random(:name => 'betsy', :kind => 'mare')
    @jake = Animal.random(:name => 'jake', :kind => 'gelding')
    @moo = Animal.random(:name => 'moo', :kind => 'cow')
    @billy = Animal.random(:name => 'billy', :kind => 'goat')
  end

  context "single protocol kind of animal" do 

    setup do 
      @floating_protocol_equine = Protocol.create(:procedure => @floating, :animal_kind => 'equine',
                                                  :description => "floating description")
      @partial = ProtocolPartial.new(@floating, @betsy, @jake)
    end

    should "be able to create a link from a procedure to its protocol" do
      text = @partial.protocol_link
      protocol_id = @floating_protocol_equine.id
      assert_xhtml(text) do
        a("floating", :href => "##{protocol_id}")
      end
    end

    should "be able to create a link to same place if duplicate procedures" do
      first_version = ProtocolPartial.new(@floating, @betsy).protocol_link.to_s
      second_version = ProtocolPartial.new(@floating, @jake).protocol_link.to_s
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
      assert { local_destination == local_link }
    end

    should "have a description anchored by the protocol name anchor" do
      text = @partial.protocol_description
      assert_xhtml(text) do
        div(/floating description/) do 
          a(:name => /\d+/)
        end
      end
    end
  end

  context "protocol does not yet exist" do 

    setup do
      @procedure_without_protocol = Procedure.random(:name => 'unknown')
      @missing_protocol = ProtocolPartial.new(@procedure_without_protocol)
    end

    should "create a harmless link" do 
      missing_text = @missing_protocol.protocol_link
      assert_xhtml(missing_text) do
        a("unknown", :href => "#no_protocol_defined")
      end
    end

    should "be able to create the destination for the link" do
      missing_text = @missing_protocol.protocol_name_anchor
      assert_xhtml(missing_text) do
        a(:name => "no_protocol_defined")
      end
    end

    should "return a harmless description" do
      missing_text = @missing_protocol.protocol_description
      procedure_name = @procedure_without_protocol.name
      assert_xhtml(missing_text) do
        div(/No protocol has yet been defined for this procedure/) do
          a(:name => "no_protocol_defined")
        end
      end
    end
  end

  context "protocol depends on the animal" do 
    setup do 
      @floating_protocol_caprine = Protocol.create(:procedure => @floating,
                                                :animal_kind => 'caprine',
                                                :description => "floating description (goat)")
      @floating_protocol_bovine = Protocol.create(:procedure => @floating,
                                                :animal_kind => 'bovine',
                                                :description => "floating description (cow)")
    end

    should_eventually "be able to create a link from a procedure/animal to its protocol" do
      text = protocol_link(@floating, @moo)
      protocol_id = @floating_protocol_bovine.id
      assert_xhtml(text) do
        a("floating", :href => "##{protocol_id}")
      end

      # ... but ...
      text = protocol_link(@floating, @billy)
      protocol_id = @floating_protocol_caprine.id
      assert_xhtml(text) do
        a("floating", :href => "##{protocol_id}")
      end
    end
  end


  def protocol_link(*args)
    partial = ProtocolPartial.new(*args)
    partial.protocol_link
  end

  def local_destination
    %r{name=["'](.*)['"]} =~ @partial.protocol_name_anchor
    $1
  end

  def local_link
    %r{href=["']#(.*)['"]} =~ @partial.protocol_link
    $1
  end

end