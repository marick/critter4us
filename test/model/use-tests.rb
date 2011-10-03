require './test/testutil/requires'
require './model/requires'

class UseTests < Test::Unit::TestCase
  def setup
    @reservation_source = flexmock("reservation source")
    Use.override_reservation_source(@reservation_source)
  end

  should "ask reservation source for data to find uses" do
    some_reservation = flexmock("some reservation")
    during {
      Use.overlapping("a timeslice")
    }.behold! {
      @reservation_source.should_receive(:overlapping).once.
                          with("a timeslice").
                          and_return([some_reservation])
      some_reservation.should_receive(:uses).once.
                             and_return(["some uses"])
    }
    assert { @result == ["some uses"] }
  end

  should "ask reservation source for data to find animals" do
    some_reservation = flexmock("some reservation")
    some_use = flexmock('some use')
    during {
      Use.animals_in_use_during("a timeslice")
    }.behold! {
      @reservation_source.should_receive(:overlapping).once.
                          with("a timeslice").
                          and_return([some_reservation])
      some_reservation.should_receive(:uses).once.
                             and_return([some_use])
      some_use.should_receive(:animal).once.
               and_return("some animal")
    }
    assert { @result == ["some animal"] }
  end
end
