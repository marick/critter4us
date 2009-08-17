$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class Date
  def inspect
    to_s
  end
end
    

class ExclusionMapTests < Test::Unit::TestCase


  def setup
    empty_tables
  end

  should "produce no exclusions if no uses" do
    Procedure.random(:name => 'only', :days_delay => 14)
    map = ExclusionMap.new(Date.new(2009, 7, 23), true)
    assert { map.to_hash == { 'only' => [] } }
  end

  should "not exclude an animal that's used for a 0-delay procedure on a different day" do
    Reservation.random(:date => Date.new(2009,9,9),
                       :morning => true) do
      use Animal.random
      use Procedure.random(:name => 'proc', :days_delay => 0)
    end
    map = ExclusionMap.new(Date.new(2009, 9, 10),
                           morning = true).to_hash
    
    assert { map == { 'proc' => [] } }
  end

  should_eventually "exclude any animal that's used in any lab at the same time" do

    Reservation.random(:date => Date.new(2009, 9, 9),
                       :morning => true,
                       :course => 'vm333') do
      use Animal.random(:name => "inuse")
      use Procedure.random(:name => 'lab procedure')
    end

    Procedure.random(:name => 'other')

    map = ExclusionMap.new(Date.new(2009, 9, 9),
                           morning = true).to_hash

    assert { map == { 'other' => ['inuse'], 'lab procedure' => ['inuse'] } }
        
  end


  BoundaryCases = [
# Reservation attempt for date after previously-made reservation
      # DELAY       USED-ON        TRY-AGAIN          OK?
[          0,       1, :morning,     1, :morning,        :NO ],        # 1
[          0,       1, :morning,     1, :afternoon,        :yes ],

[          1,       1, :morning,     1, :afternoon,      :NO ],
[          1,       1, :afternoon,   2, :morning,        :YES ],       # 4

[          2,       1, :afternoon,   3, :morning,        :YES ],

# Reservation attempt for date before previously-made reservation
      # DELAY       USED-ON        TRY-FOR-BEFORE          OK?
[          0,       1, :afternoon,   1, :afternoon,        :NO ],
[          0,       1, :afternoon,   1, :morning,          :yes],

[          1,       2, :afternoon,   2, :afternoon,        :NO],
[          1,       2, :afternoon,   2, :morning,          :NO],  # no new info but just in case
[          1,       2, :afternoon,   1, :afternoon,        :YES],     # 10
[          1,       2, :morning,     1, :morning  ,        :YES], # no new
[          1,       2, :morning,     1, :afternoon,        :YES], # perhaps surprising

[          2,       3, :afternoon,   3, :morning,          :NO],
[          2,       3, :morning,     2, :morning,          :NO],
[          2,       3, :morning,     1, :afternoon,        :YES],
[          2,       3, :afternoon,     1, :afternoon,      :YES], # no new


[          7,       3, :afternoon,     1, :afternoon,      :NO], # no new
    ]

  def self.boundary_test(row, index)
    defn = %Q{
      def test_boundary_case_#{index}
        # puts "=========== boundary test #{index}"
        # puts #{row.inspect}.inspect
        boundary = BoundaryCases[#{index}]
        prior_reservation(*boundary[0,3])
        run_attempt(*boundary[3,2])
        assert_reservation_success(boundary.last)
      end
    }
    class_eval defn
  end

  BoundaryCases.each_with_index do | row, index |
    boundary_test(row, index)
  end

  def excluded?(is_ok)
    is_ok == :NO
  end

  def prior_reservation(delay, date, time)
    @animal = Animal.random(:name => "bossie")
    @procedure = Procedure.random(:name => 'only', :days_delay => delay)
    @reservation = Reservation.random(:date => Date.new(2009, 12, date),
                                      :morning => (time == :morning))
    @use = Use.create(:animal => @animal, :procedure => @procedure, :reservation => @reservation)
    # puts "all uses:"
    # puts DB[:expanded_uses].all.inspect
  end


  def run_attempt(attempt_date, attempt_time)
    # puts "attempt at #{[attempt_date, attempt_time].inspect}"
    @map = ExclusionMap.new(Date.new(2009, 12, attempt_date),
                            attempt_time == :morning)
  end

  def assert_reservation_success(is_ok)
    expected = excluded?(is_ok) ? [@animal.name] : []
    # puts "Expect: attempt ok? #{is_ok} excluded? #{expected}"
    # puts "Actual: #{@map.to_hash.inspect}"
    assert { @map.to_hash == { 'only' => expected } }
  end


  should "work with a typical example" do
    venipuncture = Procedure.random(:name => 'venipuncture', :days_delay => 7)
    physical_exam = Procedure.random(:name => 'physical exam', :days_delay => 1)
    
    veinie = Animal.random(:name => 'veinie')
    bossie = Animal.random(:name => 'bossie')
    staggers = Animal.random(:name => 'staggers')

    eight31 = Reservation.random(:date => Date.new(2009, 8, 31)) # Previous Monday
    nine1 = Reservation.random(:date => Date.new(2009, 9, 1))  # Previous Tuesday
    nine7 = Reservation.random(:date => Date.new(2009, 9, 7))  # Today, Monday

    Use.create(:animal => bossie, :procedure => venipuncture,
               :reservation => eight31);
    Use.create(:animal => staggers, :procedure => venipuncture,
               :reservation => nine1);
    Use.create(:animal => veinie, :procedure => venipuncture,
               :reservation => nine7);
    Use.create(:animal => veinie, :procedure => physical_exam,
               :reservation => nine7);

    # What can not be scheduled today?
    actual = ExclusionMap.new(Date.new(2009, 9, 7), true).to_hash
    assert { actual['venipuncture'].include?('staggers') }
    assert { actual['venipuncture'].include?('veinie') }
    deny { actual['venipuncture'].include?('bossie') }
    assert { actual['physical exam'].include?('veinie') }
    deny { actual['physical exam'].include?('staggers') }
    deny { actual['physical exam'].include?('bossie') }

    # What can not be scheduled tomorrow?
    actual = ExclusionMap.new(Date.new(2009, 9, 8), true).to_hash
    deny { actual['venipuncture'].include?('staggers') }
    assert { actual['venipuncture'].include?('veinie') }
    deny { actual['venipuncture'].include?('bossie') }
    deny { actual['physical exam'].include?('veinie') }
    deny { actual['physical exam'].include?('staggers') }
    deny { actual['physical exam'].include?('bossie') }

    # What can not be scheduled next Sunday?
    actual = ExclusionMap.new(Date.new(2009, 9, 13), true).to_hash
    deny { actual['venipuncture'].include?('staggers') }
    assert { actual['venipuncture'].include?('veinie') }
    deny { actual['venipuncture'].include?('bossie') }
    deny { actual['physical exam'].include?('veinie') }
    deny { actual['physical exam'].include?('staggers') }
    deny { actual['physical exam'].include?('bossie') }

    # What can not be scheduled next Monday?
    actual = ExclusionMap.new(Date.new(2009, 9, 14), true).to_hash
    deny { actual['venipuncture'].include?('staggers') }
    deny { actual['venipuncture'].include?('veinie') }
    deny { actual['venipuncture'].include?('bossie') }
    deny { actual['physical exam'].include?('veinie') }
    deny { actual['physical exam'].include?('staggers') }
    deny { actual['physical exam'].include?('bossie') }
  end


end
