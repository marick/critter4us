require './test/testutil/requires'
require './strangled-src/model/requires'
require './src/views/requires'

class GetRepetitionAddingPageTest < ViewTestCase
  include HtmlAssertions

  def setup
    super
    reservation = Reservation.random(instructor: "Dr. Dawn")
    @html = @controller.haml(:reservation__repetition_adder,
                             :locals => {
                               start_date: Date.new(2001, 2, 3),
                               reservation: reservation,
                               rest_links: [Href.link("uri", "fulfillment")]
                             })
  end

  should "include some information about the reservation" do
    assert { @html['Dr. Dawn'] }
  end

  should "include a Javascript starting date" do 
    assert { @html['new Date(2001, 1, 3)'] }
  end

  should "include the fulfillment link" do
    assert_text_has_attributes(@html, "head link", href: "uri", rel: "fulfillment")
  end

end
