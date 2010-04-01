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
    reservation = Reservation.random(:first_date => expected_date,
                                     :last_date => expected_date,
                                     :times => TimeSet.new(MORNING),
                                     :instructor => expected_instructor,
                                     :course => expected_course)
    actual = ReservationView.new(:reservation => reservation).to_s
    assert { actual.include?(expected_date) }
    assert { actual.include?(expected_morning) }
    assert { actual.include?(expected_instructor) }
    assert { actual.include?(expected_course) }
  end

  should  "know how to display time of day" do
    morning = Reservation.random(:times => TimeSet.new(MORNING))
    morning_view = ReservationView.new(:reservation => morning)
    
    afternoon = Reservation.random(:times => TimeSet.new(MORNING, AFTERNOON))
    afternoon_view = ReservationView.new(:reservation => afternoon)

    evening = Reservation.random(:times => TimeSet.new(MORNING, AFTERNOON, EVENING))
    evening_view = ReservationView.new(:reservation => evening)

    assert { 'morning' == morning_view.time_of_day(morning) }
    assert { 'morning, afternoon' == afternoon_view.time_of_day(afternoon) }
    assert { 'morning, afternoon, evening' == evening_view.time_of_day(evening) }
  end

  context "a real, modestly complicated reservation" do 

    setup do
      @floating = Procedure.random(:name => 'floating')
      @venipuncture = Procedure.random(:name => 'venipuncture')
      @milking = Procedure.random(:name => 'milking')

      @betsy = Animal.random(:name => 'betsy', :kind => 'cow', :procedure_description_kind => 'bovine')
      @jake = Animal.random(:name => 'jake', :kind => 'stallion', :procedure_description_kind => 'equine')
      @test_data = {
        :instructor => 'marge',
        :course => 'vm333',
        :first_date => Date.new(2001, 2, 4),
        :last_date => Date.new(2001, 2, 4),
        :times => ['afternoon'],
        :groups => [ {:procedures => ['floating', 'venipuncture'],
                       :animals => ['betsy']},
                     {:procedures => ['venipuncture', 'milking'],
                       :animals => ['jake', 'betsy']}]
      }
      ProcedureDescription.random(:procedure => @floating, :description => 'floating description')
      ProcedureDescription.random(:procedure => @venipuncture, :description => 'venipuncture description')
      ProcedureDescription.random(:procedure => @milking, :description => 'milking description')

      @reservation = Reservation.create_with_groups(@test_data)
      
    end

    should "be able to display different groups" do 
      text = ReservationView.new(:reservation => @reservation).to_s
      assert { text =~ /betsy.*floating.*venipuncture/m }
      assert { text =~ /betsy.*jake.*milking.*venipuncture/m }
    end

    should "use a ProcedurePartial to create a in-page link to a description" do 
      text = ReservationView.new(:reservation => @reservation).to_pretty
      expected_link = ProcedurePartial.for(@venipuncture, @jake, @betsy).linkified_procedure_name
      assert_match( /#{Regexp.escape(expected_link)}/, text )
    end

    should "use a ReservationViewPrelude to create generic text" do 
      text = ReservationView.new(:reservation => @reservation).to_pretty
      expected_text = ReservationViewPrelude.new(:procedure_description_kinds => ['bovine', 'equine']).to_pretty
      assert { text.include? expected_text } 
    end
  end
end

