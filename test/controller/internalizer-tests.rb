$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller/internalizer'
require 'model/reservation'
require 'model/timeslice'

class InternalizerTests < FreshDatabaseTestCase
  should "turn hash keys into symbols" do
    input = { 'key' => 'value' } 
    expected = { :key => 'value' }
    assert { expected == Internalizer.new.symbol_keys(input) }
  end

  should "convert to consistent internal format" do
    input = {
      "stringkey" => "value",
      "time" => MORNING,
      "times" => [MORNING, AFTERNOON],
      "date" => "2009-12-01",
      "firstDate" => "2000-01-01",
      "lastDate" => "2000-12-31",
      "groups" => [ {'animals' => ['josie', 'frank'],
                      'procedures' => ['venipuncture']}],
      "timeslice" => {"firstDate" => "2008-08-08", 'etc' => '...'}.to_json
    }
    actual = Internalizer.new.convert(input)
    expected = {
      :stringkey => 'value', 
      :time => MORNING,
      :times => Set.new([AFTERNOON, MORNING]),
      :date => Date.new(2009,12,1),
      :firstDate => Date.new(2000,1,1),
      :lastDate => Date.new(2000,12,31),
      :groups => [{:animals => ['josie', 'frank'],
                    :procedures => ['venipuncture']}],
      :timeslice => {:firstDate => Date.new(2008, 8, 8), :etc => "..." },
    }
    assert { actual == expected }
  end

  should "interpret a 'data' key as pointing to json data to translate" do
    input = { 
      'top_level' => "top level",
      'data' => { 
        :date => '2009-12-12',
        :second => 'second'
      }.to_json
    }

    actual = Internalizer.new.convert(input)

    expected = {
      :top_level => "top level",
      :data => {
        :date => Date.new(2009, 12, 12),
        :second => 'second'
      }
    }

    assert_equal(expected, actual)
  end

  context "reservations" do
    should "be able to fetch a reservation" do 
      reservation = Reservation.random
      fetched = Internalizer.new.find_reservation({'tag' => reservation.id.to_s}, 'tag')
      assert_equal(reservation.id, fetched.id)
    end

    should "return a null object if no reservation named" do 
      fetched = Internalizer.new.find_reservation({}, 'tag')
      assert { fetched.acts_as_empty? }
    end
  end

  context "timeslice" do 
    setup do 
      @params = {'firstDate' => '2009-12-12', 'lastDate' => '2009-12-12',
                 'times' => ['morning']}
      @internalizer = Internalizer.new
    end

    should "be able to make a timeslice" do
      reservation = Reservation.random
      timeslice = @internalizer.make_timeslice(@params, reservation)
      # Todo: only uses degenerate timeslices so far.
      assert_equal(Date.new(2009,12,12), timeslice.date)
      assert_equal(MORNING, timeslice.time)
      assert_equal(reservation, timeslice.ignored_reservation)
    end

    should "be able to make a timeslice without an associated reservation" do 
      timeslice = @internalizer.make_timeslice(@params)
      assert { timeslice.ignored_reservation.acts_as_empty? }
    end

    should "be able to make a reservation from a pure date" do 
      timeslice = @internalizer.make_timeslice({'date' => '2008/09/08'})
      assert_equal(Date.new(2008,9,8), timeslice.date)
      assert_equal(MORNING, timeslice.time)  # TODO: Will eventually not be needed.
      assert { timeslice.ignored_reservation.acts_as_empty? }
    end
  end
end
