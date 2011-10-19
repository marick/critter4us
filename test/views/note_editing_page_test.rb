require './test/testutil/requires'
require './model/requires'
require './views/requires'

class NoteEditingPageTests < ViewTestCase

  def render(hash)
    reservation = Reservation.random(hash)
    @renderer.render_page(:get_note_editing_page, :reservation => reservation)
  end

  should "use reservation to populate page upon GET" do
    assert { render(:instructor => 'Dr. Dawn')['Dr. Dawn'] }
  end

  should "not spuriously indent multi-line notes" do
    # http://haml-lang.com/docs/yardoc/file.FAQ.html#q-preserve
    assert { render(:note => "Multi\nLine")["Multi&#x000A;Line"] }
  end
end
