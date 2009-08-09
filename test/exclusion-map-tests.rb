require 'test/testutil/requires'
require 'test/testutil/config'
require 'test/testutil/dbhelpers'
require 'admin/tables'
require 'model'


class ExclusionMapTests < Test::Unit::TestCase
  RulesForAttemptsAfterAReservation = [
      # DELAY       USED-ON        TRY-AGAIN          OK?
[          0,       1, :morning,     1, :morning,        :NO ],
[          0,       1, :afternoon,   1, :morning,        :yes ],

[          1,       1, :morning,     1, :afternoon,      :NO ],
[          1,       1, :afternoon,   2, :morning,        :YES ],

[          2,       1, :afternoon,   3, :morning,        :YES ],
    ]


  RulesForAttemptsBeforeAReservation = [
      # DELAY       USED-ON        TRY-FOR-BEFORE          OK?
[          0,       1, :afternoon,   1, :afternoon,        :NO ],
[          0,       1, :afternoon,   1, :morning,          :yes],

[          1,       2, :afternoon,   2, :morning,          :NO],
[          1,       2, :afternoon,   1, :afternoon,        :YES],
[          1,       2, :morning,     1, :afternoon,        :YES],

[          2,       3, :morning,     1, :afternoon,        :YES],
[          2,       3, :morning,     2, :morning,          :NO],
    ]

  def set_up_boundary_test(delay, date, time)
  end


  def run_attempt(attempt_date, attempt_time)
  end


  def setup
    empty_tables
  end

  should "produce no exclusions if no uses" do
    Procedure.create(:name => 'only', :days_delay => 14)
    map = ExclusionMap.new(Date.new(2009, 7, 23))
    assert { map.to_hash == { 'only' => [] } }
  end

  context "boundaries" do

    setup do
      @bossie = Animal.create(:name => "bossie");
    end


    should_eventually "handle boundaries" do

=begin
      procedure_with_delay = proc { | delay | 
        Procedure.create(:name => 'only', :days_delay => delay)
      }

      bossie_used = proc { | hash | 
        @procedure = procedure_with_delay.call(hash[:with_delay])
        @reservation = Reservation.create(:date => Date.new(2009, 12, 1))
        Use.create(:animal => @bossie, :procedure => @procedure, :reservation => @reservation)
      }

      try_for_day = proc { | day | 
        ExclusionMap.new(Date.new(2002, 12, day))
      }
      bossie_used.call(:on:with_delay => 0)
      expected = { 'only' => [] }
      map = try_for_day.call(1)
      assert { map.to_hash == expected }
=end
    end

  end

  should_eventually "work with a typical example" do
    venipuncture = Procedure.create(:name => 'venipuncture', :days_delay => 7)
    physical_exam = Procedure.create(:name => 'physical exam', :days_delay => 1)
    
    veinie = Animal.create(:name => 'veinie')
    bossie = Animal.create(:name => 'bossie')
    staggers = Animal.create(:name => 'staggers')

    eight31 = Reservation.create(:date => Date.new(2009, 8, 31)) # Previous Monday
    nine1 = Reservation.create(:date => Date.new(2009, 9, 1))  # Previous Tuesday
    nine7 = Reservation.create(:date => Date.new(2009, 9, 7))  # Today, Monday

    Use.create(:animal => bossie, :procedure => venipuncture,
               :reservation => eight31);
    Use.create(:animal => staggers, :procedure => venipuncture,
               :reservation => nine1);
    Use.create(:animal => veinie, :procedure => venipuncture,
               :reservation => nine7);
    Use.create(:animal => veinie, :procedure => physical_exam,
               :reservation => nine7);

    # What can not be scheduled today?
    actual = ExclusionMap.new(Date.new(2009, 9, 7)).to_hash
    assert { actual['venipuncture'].include?('staggers') }
    assert { actual['venipuncture'].include?('veinie') }
    deny { actual['venipuncture'].include?('bossie') }
    assert { actual['physical exam'].include?('veinie') }
    deny { actual['physical exam'].include?('staggers') }
    deny { actual['physical exam'].include?('bossie') }

    # What can not be scheduled tomorrow?
    actual = ExclusionMap.new(Date.new(2009, 9, 8)).to_hash
    deny { actual['venipuncture'].include?('staggers') }
    assert { actual['venipuncture'].include?('veinie') }
    deny { actual['venipuncture'].include?('bossie') }
    deny { actual['physical exam'].include?('veinie') }
    deny { actual['physical exam'].include?('staggers') }
    deny { actual['physical exam'].include?('bossie') }

    # What can not be scheduled next Sunday?
    actual = ExclusionMap.new(Date.new(2009, 9, 13)).to_hash
    deny { actual['venipuncture'].include?('staggers') }
    assert { actual['venipuncture'].include?('veinie') }
    deny { actual['venipuncture'].include?('bossie') }
    deny { actual['physical exam'].include?('veinie') }
    deny { actual['physical exam'].include?('staggers') }
    deny { actual['physical exam'].include?('bossie') }

    # What can not be scheduled next Monday?
    actual = ExclusionMap.new(Date.new(2009, 9, 14)).to_hash
    deny { actual['venipuncture'].include?('staggers') }
    deny { actual['venipuncture'].include?('veinie') }
    deny { actual['venipuncture'].include?('bossie') }
    deny { actual['physical exam'].include?('veinie') }
    deny { actual['physical exam'].include?('staggers') }
    deny { actual['physical exam'].include?('bossie') }
  end


end
