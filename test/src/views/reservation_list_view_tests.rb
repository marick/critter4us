require './test/testutil/requires'
require './strangled-src/view/requires'
require './src/db/shapes.rb'
require 'stunted'

class NewReservationListViewTests < Test::Unit::TestCase
  include ViewHelper
  include HtmlAssertions
  include Stunted::FHUtil

  def setup
    @reservation = F(:pk => "primary-key",
                     :first_date => Date.new(2008, 8, 8),
                     :last_date => Date.new(2008, 8, 9),
                     :time_bits => "100",
                     :instructor => "morin",
                     :course => "vm333",
                     :animal_names => ["betsy", "fred"],
                     :procedure_names => ["p1", "p2"],
                     :note => "here is a note")
    @days = 321
    @html = NewReservationListView.new(:reservations => [@reservation],
                                       :days_to_display_after_deletion => @days).to_html
  end

  should "contain bits of reservation" do
    assert { Regexp.new(@reservation.instructor) =~ @html }
    assert { Regexp.new(@reservation.course) =~ @html }
    assert { Regexp.new("betsy, fred") =~ @html }
    assert { Regexp.new("p1, p2") =~ @html }
  end

  should "contain well-formed date information" do
    assert { Regexp.new("2008-08-08 to 2008-08-09") =~ @html }
    assert { Regexp.new("morning") =~ @html }
  end

  should "contain well-formed delete button" do
    assert { @html.include? delete_button("/reservation/#{@reservation.pk}/#{@days}") } 
  end

  should "contain well-formed edit button" do
    assert_text_has_selector(@html, "td")
    assert_text_has_attributes(@html, "input", :type => 'button', :value => "Edit",
                               :onclick => "window.parent.AppForwarder.edit(#{@reservation.pk})")
    # assert_xhtml(output) do
    #   td do
    #     input(:type => 'button', :value => "Edit",
    #           :onclick => "window.parent.AppForwarder.edit(#{reservation.id})")
    #   end
    # end
  end

  should "contain well-formed copy button" do
    assert_text_has_selector(@html, "td")
    assert_text_has_attributes(@html, "input", :type => 'button', :value => "Copy",
                               :onclick => "window.parent.AppForwarder.copy(#{@reservation.pk})")
    # assert_xhtml(output) do
    #   td do
    #     input(:type => 'button', :value => "Copy",
    #           :onclick => "window.parent.AppForwarder.copy(#{reservation.id})")
    #   end
    # end
  end

  should "contain a link to the reservation view" do
    assert_text_has_selector(@html, "td")
    assert_text_has_selector(@html, "a", :text => /View/)
    assert_text_has_attributes(@html, "a",
                               :href => Regexp.new(Href.reservation_viewing_page(@reservation.pk)))

    # assert_xhtml(output) do
    #   td do
    #     a(/View/, :href => %r{/reservation/#{reservation.pk}})
    #   end
    # end
  end

  should "display the note and an editing link" do
    assert { %r{<p>.*here is a note.*</p>} =~ @html }
    assert { Regexp.new(Href.reservation_viewing_page(@reservation.pk)) =~ @html }
  end

end

