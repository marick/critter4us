require './test/testutil/requires'
require './model/requires'
require './view/requires'

class ReservationViewPreludeTests < FreshDatabaseTestCase
  
  should "include a generic prelude" do
    text = ReservationViewPrelude.new(:procedure_description_kinds => []).to_s
    assert { text =~ /You must adhere to the approved procedures/ } 
  end

  should "provide preludes for each different species" do 
    text = ReservationViewPrelude.new(:procedure_description_kinds => ['bovine', 'equine']).to_s
    assert_match(/For all bovine procedures:/, text)
    assert_match(/For all equine procedures:/, text)
  end

  should "provide a note if given unknown species" do 
    text = ReservationViewPrelude.new(:procedure_description_kinds => ['foo']).to_s
    assert_match(/For all foo procedures:/, text)
    assert_match(/No description.*yet/, text)
  end

  should "not provide prelude unless needed" do 
    text = ReservationViewPrelude.new(:procedure_description_kinds => ['bovine']).to_s
    assert_match(/For all bovine procedures:/, text)
    deny { /For all equine procedures:/ =~ text } 
  end
end

