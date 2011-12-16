require './test/testutil/requires'
require './strangled-src/model/requires'
require './src/views/requires'

class NoteEditingPageTests < ViewTestCase
  include HtmlAssertions

  def setup
    super
    reservation = Reservation.random(instructor: "Dr. Dawn")
    @html = @controller.haml(:reservation__note_editor,
                             :locals => {
                               reservation: reservation,
                               rest_links: [Href.link("uri", "fulfillment")]
                             })
  end

  should "include some information about the reservation" do
    assert { @html['Dr. Dawn'] }
  end

  should "include the fulfillment link" do
    assert_text_has_attributes(@html, "link", href: "uri", rel: "fulfillment")
  end

  should "contain place to put the fulfillment URI" do
    assert_text_has_attributes(@html, "form", :id => "note_form")
  end

end
