require './test/testutil/requires'
require './model/requires'
require './view/requires'

class ReservationNoteViewTests < FreshDatabaseTestCase
  include ViewHelper
  include HtmlAssertions

  should "contain a form to update notes" do
    note_content = "THIS IS A NOTE"
    reservation = Reservation.random(:note => note_content)
    output = ReservationNoteView.new(:reservation => reservation).to_html
    assert_text_has_attributes(output, 'form', :method=>"POST",
                               :action => Href.note_editing_page(reservation))
    assert_text_has_attributes(output, 'input',
                                :type=>"submit",  :value => 'Update Note')
    assert_text_has_attributes(output, 'textarea', :name => "note")
    assert_text_has_selector(output, 'textarea', :text => note_content)
  end
end

