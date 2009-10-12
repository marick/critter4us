$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ReservationViewTests < FreshDatabaseTestCase
  should "include session information in output" do
    expected_date = '2009-09-03'
    expected_morning = "morning"
    expected_instructor = "d-morin"
    expected_course = "vm333"
    reservation = Reservation.random(:date => expected_date,
                                     :morning => true,
                                     :instructor => expected_instructor,
                                     :course => expected_course)
    actual = ReservationView.new(:reservation => reservation).to_s
    assert { actual.include?(expected_date) }
    assert { actual.include?(expected_morning) }
    assert { actual.include?(expected_instructor) }
    assert { actual.include?(expected_course) }
  end

  should "know how to display time of day" do
    morning = Reservation.random(:morning => true)
    morning_view = ReservationView.new(:reservation => morning)
    
    afternoon = Reservation.random(:morning => false)
    afternoon_view = ReservationView.new(:reservation => afternoon)

    assert { 'morning' == morning_view.time_of_day(morning) }
    assert { 'afternoon' == afternoon_view.time_of_day(afternoon) }
  end

  context "a real, modestly complicated reservation" do 

    setup do
      @floating = Procedure.random(:name => 'floating', :protocol => "floating protocol")
      @venipuncture = Procedure.random(:name => 'venipuncture', :protocol => "venipuncture protocol")
      @milking = Procedure.random(:name => 'milking', :protocol => "milking protocol")

      @betsy = Animal.random(:name => 'betsy')
      @jake = Animal.random(:name => 'jake')
      @test_data = {
        :instructor => 'marge',
        :course => 'vm333',
        :date => Date.new(2001, 2, 4),
        :morning => false,
        :groups => [ {:procedures => ['floating', 'venipuncture'],
                       :animals => ['betsy']},
                     {:procedures => ['venipuncture', 'milking'],
                       :animals => ['jake', 'betsy']}]
      }
      @reservation = Reservation.create_with_groups(@test_data)
      
    end

    should "be able to display different groups" do 
      text = ReservationView.new(:reservation => @reservation).to_s
      assert { text =~ /betsy.*floating.*venipuncture/m }
      assert { text =~ /betsy.*jake.*milking.*venipuncture/m }
    end

    should "use a ProcedurePartial to create a in-page link to protocol" do 
      text = ReservationView.new(:reservation => @reservation).to_s
      expected_link = ProcedurePartial.new(@floating).protocol_link
      assert_match( /#{Regexp.escape(expected_link)}/, text )
    end

    should "wrap text of protocol in an anchor" do 
      actual_text = ReservationView.new(:reservation => @reservation).to_s

      expected_name = ProcedurePartial.new(@floating).protocol_name_anchor
      assert_match( /#{Regexp.escape(expected_name)}/, actual_text )

      expected_text = @floating.protocol
      assert_match( /#{Regexp.escape(expected_text)}/, actual_text )
    end

    should "only use a procedure's protocol once" do 
      actual_text = ReservationView.new(:reservation => @reservation).to_s
      expected_text = @floating.protocol
      pp expected_text
      deny { /#{expected_text}.*#{expected_text}/ =~ actual_text }
    end

  end
  
end

