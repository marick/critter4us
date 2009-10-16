$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ReservationViewPreludeTests < FreshDatabaseTestCase
  
  should "include a generic prelude" do
    text = ReservationViewPrelude.new(:protocol_kinds => []).to_s
    assert { text =~ /You must adhere to the approved procedures/ } 
  end

  should "provide preludes for each protocol kind" do 
    text = ReservationViewPrelude.new(:protocol_kinds => ['bovine', 'equine']).to_s
    assert_match(/For all bovine procedures:/, text)
    assert_match(/For all equine procedures:/, text)
  end

  should "provide a note if given unknown protocol kind" do 
    text = ReservationViewPrelude.new(:protocol_kinds => ['foo']).to_s
    assert_match(/For all foo procedures:/, text)
    assert_match(/No description.*yet/, text)
  end

  should "not provide prelude unless needed" do 
    text = ReservationViewPrelude.new(:protocol_kinds => ['bovine']).to_s
    assert_match(/For all bovine procedures:/, text)
    deny { /For all equine procedures:/ =~ text } 
  end
end

