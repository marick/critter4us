$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ProcedurePartialTests < FreshDatabaseTestCase
  
  def setup
    @floating = Procedure.random(:name => 'floating')
    @partial = ProcedurePartial.new(@floating)

  end

  should "be able to create a link from a procedure to its explanation" do
    text = @partial.protocol_link
    assert_xhtml(text) do
      a("floating", :href => /^#/)
    end
  end

  should "be able to create a link to same place if duplicate procedures" do
    first_version = ProcedurePartial.new(@floating).protocol_link.to_s
    second_version = ProcedurePartial.new(@floating).protocol_link.to_s
    assert { first_version == second_version }
  end

  should "be able to create the destination for the link" do
    text = @partial.protocol_name_anchor
    assert_xhtml(text) do
      a(:name => /^#/)
    end
  end

  should "have a destination whose tag matches the link" do 
    from = within_page_destination_for_attribute('href', :protocol_link)
    to = within_page_destination_for_attribute('name', :protocol_name_anchor)
    assert { from == to }
  end

  def within_page_destination_for_attribute(name, accessor)
    %r{#{name}=["']#(.*)["']} =~ @partial.send(accessor)
    $1
  end

end


