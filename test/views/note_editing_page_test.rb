require './test/testutil/requires'
require './model/requires'
require './views/requires'

class NoteEditingPageTests < ViewTestCase

  def setup 
    super
    @reservation = Reservation.random(:instructor => 'Dr. Dawn')
  end
  
  should "use reservation to populate page upon GET" do
    html = @renderer.render_page(:get_note_editing_page, :reservation => @reservation)
    assert { /Dr. Dawn/ =~ html }
  end
end
