require './test/testutil/requires'
require './strangled-src/model/requires'
require './src/views/requires'

class NoteEditingPageTests < ViewTestCase

  def render(hash)
    reservation = Reservation.random(hash)
    @renderer.render_page(:reservation__note_editor, :reservation => reservation)
  end

  should "use reservation to populate page upon GET" do
    assert { render(:instructor => 'Dr. Dawn')['Dr. Dawn'] }
  end

  should "not spuriously indent multi-line notes" do
    # http://haml-lang.com/docs/yardoc/file.FAQ.html#q-preserve
    assert { render(:note => "Multi\nLine")["Multi&#x000A;Line"] }
  end
end
