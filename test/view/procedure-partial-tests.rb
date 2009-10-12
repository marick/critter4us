$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ProcedurePartialTests < Test::Unit::TestCase

  should "show a link from a procedure to its explanation" do
    partial = ProcedurePartial.new(Procedure.random(:name => 'floating'))
    text = partial.protocol_link
    assert_xhtml(text) do
      a("floating", :href => /^#/)
    end
  end

  should "show a link to same place if duplicate procedures" do
    floating = Procedure.random(:name => 'floating')
    first_version = ProcedurePartial.new(floating).protocol_link.to_s
    second_version = ProcedurePartial.new(floating).protocol_link.to_s
    assert { first_version == second_version }
  end

end


