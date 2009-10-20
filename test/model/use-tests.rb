$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class Date
  def inspect
    to_s
  end
end


class UseTests < FreshDatabaseTestCase

  context "removing animals in use" do
    should "be able to remove animals in use" do
      Reservation.random(:date => Date.new(2009, 9, 9),
                         :morning => true,
                         :course => 'vm333') do
        use Animal.random(:name => "inuse")
        use Procedure.random(:name => 'lab procedure')
      end

      actual = Use.remove_names_for_animals_in_use(['helfrig', 'inuse'], 
                                                   Date.new(2009, 9, 9), true)
      assert { ['helfrig'] == actual }
    end

    should_eventually "not remove animals in use at different times" do
      not_inuse = Animal.random(:name => "not inuse")

      Reservation.random(:date => Date.new(2009, 9, 1),
                         :morning => true,
                         :course => 'vm333') do
        use not_inuse
        use Procedure.random(:name => 'lab procedure')
      end
      Reservation.random(:date => Date.new(2009, 9, 9),
                         :morning => false,
                         :course => 'vm333') do
        use not_inuse
        use Procedure.random(:name => 'lab procedure')
      end

      actual = Use.remove_names_for_animals_in_use(['helfrig', 'not inuse'], 
                                                   Date.new(2009, 9, 9), true)
      assert { ['helfrig', 'not inuse'] == actual }
    end

  end

  context "uses for which animals are unavailable" do 
    should "include the null case" do
      Procedure.random(:name => 'only', :days_delay => 14)
      pairs = Use.combos_unavailable_at(Date.new(2009, 7, 23), true)
      assert { pairs == [] }
    end

    should "include ALL procedures for an animal used in a lab at the same time" do

      Reservation.random(:date => Date.new(2009, 9, 9),
                         :morning => true,
                         :course => 'vm333') do
        use Animal.random(:name => "inuse")
        use Procedure.random(:name => 'lab procedure')
      end

      Procedure.random(:name => 'other')

      pairs = Use.combos_unavailable_at(Date.new(2009, 9, 9),
                                        morning = true)

      assert { pairs.include?(['other', 'inuse']) }
      assert { pairs.include?(['lab procedure', 'inuse']) }
    end

    should "not exclude an animal that's used for a 0-delay procedure on a different day" do
      Reservation.random(:date => Date.new(2009,9,9),
                         :morning => true) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      pairs = Use.combos_unavailable_at(Date.new(2009, 9, 10),
                                        morning = true)
      
      assert { pairs == [] }
    end

    should "exclude an animal if that animal has been used for the same procedure too recently" do
      Reservation.random(:date => Date.new(2009,9,9),
                         :morning => true) do
        use Animal.random(:name => 'recent')
        use Procedure.random(:name => 'proc', :days_delay => 15)
      end
      pairs = Use.combos_unavailable_at(Date.new(2009, 9, 10),
                                        morning = true)
      
      assert { pairs == [['proc', 'recent']] }
    end
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

  
    only_eight31_group = Group.create(:reservation => eight31)
    only_nine1_group = Group.create(:reservation => nine1)
    only_nine7_group = Group.create(:reservation => nine7)

  
    Use.create(:animal => bossie, :procedure => venipuncture,
               :group => only_eight31_group);
    Use.create(:animal => staggers, :procedure => venipuncture,
               :group => only_nine1_group);
    Use.create(:animal => veinie, :procedure => venipuncture,
               :group => only_nine7_group);
    Use.create(:animal => veinie, :procedure => physical_exam,
               :group => only_nine7_group);

    # What can not be scheduled today?
    actual = Use.combos_unavailable_at(Date.new(2009, 9, 7), true)
    assert { actual.include?(['venipuncture', 'staggers']) }
    assert { actual.include?(['venipuncture', 'veinie']) }
    deny { actual.include?(['venipuncture', 'bossie']) }
    assert { actual.include?(['physical exam', 'veinie']) }
    deny { actual.include?(['physical exam', 'staggers']) }
    deny { actual.include?(['physical exam', 'bossie']) }

    # What can not be scheduled tomorrow?
    actual = Use.combos_unavailable_at(Date.new(2009, 9, 8), true)
    deny { actual.include?(['venipuncture', 'staggers']) }
    assert { actual.include?(['venipuncture', 'veinie']) }
    deny { actual.include?(['venipuncture', 'bossie']) }
    deny { actual.include?(['physical exam', 'veinie']) }
    deny { actual.include?(['physical exam', 'staggers']) }
    deny { actual.include?(['physical exam', 'bossie']) }

    # What can not be scheduled next Sunday?
    actual = Use.combos_unavailable_at(Date.new(2009, 9, 13), true)
    deny { actual.include?(['venipuncture', 'staggers']) }
    assert { actual.include?(['venipuncture', 'veinie']) }
    deny { actual.include?(['venipuncture', 'bossie']) }
    deny { actual.include?(['physical exam', 'veinie']) }
    deny { actual.include?(['physical exam', 'staggers']) }
    deny { actual.include?(['physical exam', 'bossie']) }

    # What can not be scheduled next Monday?
    actual = Use.combos_unavailable_at(Date.new(2009, 9, 14), true)
    deny { actual.include?(['venipuncture', 'staggers']) }
    deny { actual.include?(['venipuncture', 'veinie']) }
    deny { actual.include?(['venipuncture', 'bossie']) }
    deny { actual.include?(['physical exam', 'veinie']) }
    deny { actual.include?(['physical exam', 'staggers']) }
    deny { actual.include?(['physical exam', 'bossie']) }
  end


end


class DetailsAboutTimingTests < FreshDatabaseTestCase

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
[          0,       1, :afternoon,   1, :morning,          :YES],

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
    group = Group.create(:reservation => @reservation)
    @use = Use.create(:animal => @animal, :procedure => @procedure, :group => group)
  end


  def run_attempt(attempt_date, attempt_time)
    # puts "attempt at #{[attempt_date, attempt_time].inspect}"
    @pairs = Use.combos_unavailable_at(Date.new(2009, 12, attempt_date),
                                       attempt_time == :morning)
  end

  def assert_reservation_success(is_ok)
    expected = excluded?(is_ok) ? [['only', @animal.name]] : []
    # puts "actual: #{@pairs}"
    # puts "expected: #{expected}"
    assert { @pairs == expected }
  end

end
