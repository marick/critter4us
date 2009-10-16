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

  should  "know how to display time of day" do
    morning = Reservation.random(:morning => true)
    morning_view = ReservationView.new(:reservation => morning)
    
    afternoon = Reservation.random(:morning => false)
    afternoon_view = ReservationView.new(:reservation => afternoon)

    assert { 'morning' == morning_view.time_of_day(morning) }
    assert { 'afternoon' == afternoon_view.time_of_day(afternoon) }
  end

  context "a real, modestly complicated reservation" do 

    setup do
      @floating = Procedure.random(:name => 'floating')
      @venipuncture = Procedure.random(:name => 'venipuncture')
      @milking = Procedure.random(:name => 'milking')

      @betsy = Animal.random(:name => 'betsy', :kind => 'cow')
      @jake = Animal.random(:name => 'jake', :kind => 'stallion')
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
      Protocol.random(:procedure => @floating, :description => 'floating description')
      Protocol.random(:procedure => @venipuncture, :description => 'venipuncture description')
      Protocol.random(:procedure => @milking, :description => 'milking description')

      @reservation = Reservation.create_with_groups(@test_data)
      
    end

    should "be able to display different groups" do 
      text = ReservationView.new(:reservation => @reservation).to_s
      assert { text =~ /betsy.*floating.*venipuncture/m }
      assert { text =~ /betsy.*jake.*milking.*venipuncture/m }
    end

    should "use a ProtocolPartial to create a in-page link to protocol" do 
      text = ReservationView.new(:reservation => @reservation).to_pretty
      expected_link = ProtocolPartial.for(@venipuncture, @jake, @betsy).linkified_procedure_name
      assert_match( /#{Regexp.escape(expected_link)}/, text )
    end

    should "use a ReservationViewPrelude to create generic text" do 
      text = ReservationView.new(:reservation => @reservation).to_pretty
      expected_text = ReservationViewPrelude.new(:protocol_kinds => ['bovine', 'equine']).to_pretty
      assert_match( /#{Regexp.escape(expected_text)}/, text )
    end
  end
end

