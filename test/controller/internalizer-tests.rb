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
      "timeslice" => {"firstDate" => "2008-08-08", "lastDate" => "2009-09-09", 
                      "times" => ["evening"] }
    }

    actual = Internalizer.new.convert(input)

    expected = {
      :stringkey => 'value', 
      :time => MORNING,
      :times => TimeSet.new(AFTERNOON, MORNING),
      :date => Date.new(2009,12,1),
      :first_date => Date.new(2000,1,1),
      :last_date => Date.new(2000,12,31),
      :groups => [{:animals => ['josie', 'frank'],
                    :procedures => ['venipuncture']}],
      :timeslice => Timeslice.new(Date.new(2008, 8, 8),
                                  Date.new(2009, 9, 9),
                                  TimeSet.new(EVENING))
    }
    assert_equal(expected, actual)
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

  should "convert reservation data" do 
    params = {
      'reservation_data' => {
        'timeslice' => {
          'firstDate' => '2008-08-08', 
          'lastDate' => '2009-09-09', 
          'times' => ['morning']
        },
        'instructor' => 'morin',
        'course' => 'vm333',
        'groups' => [ { 'procedures' => ['p1', 'p2'],
                        'animals' => ['a1', 'a2']
                      } ]
      }.to_json
    }

    actual = Internalizer.new.convert(params)

    expected = {
      :reservation_data => {
        :timeslice => Timeslice.new(Date.new(2008,8,8),
                                    Date.new(2009,9,9),
                                    TimeSet.new(MORNING)),
        :instructor => 'morin',
        :course => 'vm333',
        :groups => [ { :procedures => ['p1', 'p2'],
                       :animals => ['a1', 'a2']
                      } ]
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

  should "convert an array of animal descriptions" do 
    expected = [ {'name' => 'betsy', 'species' => 'caprine', 'note' => 'male'} ]
    actual = Internalizer.new.convert_animal_descriptions(expected.to_json)
    assert_equal(expected, actual)
  end

  context "timeslice" do 
    setup do 
      @data = {'firstDate' => '2009-12-12', 'lastDate' => '2009-12-12',
               'times' => ['morning']}.to_json
      @internalizer = Internalizer.new
    end

    should "be able to make a timeslice from JSON" do
      reservation = Reservation.random
      timeslice = @internalizer.make_timeslice(@data)
      assert_equal(Date.new(2009,12,12), timeslice.first_date)
      assert_equal(Date.new(2009,12,12), timeslice.last_date)
      assert_equal(TimeSet.new(MORNING), timeslice.times)
    end

    should "be able to make a timeslice from a pure date" do 
      timeslice = @internalizer.make_timeslice_from_date('2008/09/08')
      assert { timeslice.first_date == Date.new(2008,9,8) }
      assert { timeslice.last_date == Date.new(2008,9,8) }
      assert { timeslice.times == TimeSet.new(MORNING, AFTERNOON, EVENING) } 
    end

  end

  context "integer_or_nil" do
    should "convert a string to an integer" do 
      assert_equal(32, Internalizer.new.integer_or_nil("32"))
    end
    should "leave nil alone" do 
      assert_equal(nil, Internalizer.new.integer_or_nil(nil))
    end

    should "convert an empty string to nil" do 
      assert_equal(nil, Internalizer.new.integer_or_nil(''))
    end
  end

  
end
