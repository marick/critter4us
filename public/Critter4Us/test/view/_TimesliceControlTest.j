@import <Critter4Us/test/testutil/ScenarioTestCase.j>
@import <Critter4Us/view/TimesliceControl.j>

@implementation _TimesliceControlTest : ScenarioTestCase
{
  TimesliceControl sut;
}

- (void) setUp
{
  sut = [[TimesliceControl alloc] initAtX: 0 y: 0];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardCollaborators: ['timeControl', 'dateControl']];
}


- (void) test_timeslices_are_stored_in_controls
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
  			      lastDate: '2009-12-11'
  				 times: [ [Time morning], [Time evening] ]];

  [scenario
    during: function() {
      [sut setTimeslice: timeslice];
    }
  behold: function() {
      [sut.dateControl shouldReceive: @selector(setFirst:last:)
				with: ['2009-12-10', '2009-12-11']];
      [sut.timeControl shouldReceive: @selector(setTimes:)
				with: [timeslice.times]];
    }];
}


- (void) test_timeslices_are_retrieved_from_controls
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
  			      lastDate: '2009-12-11'
  				 times: [ [Time morning], [Time evening] ]];

  [scenario
    during: function() {
      [sut timeslice];
    }
  behold: function() {
      [sut.dateControl shouldReceive: @selector(firstDate)
			      andReturn: '2009-12-10'];
      [sut.dateControl shouldReceive: @selector(lastDate)
			     andReturn: '2009-12-11'];
      [sut.timeControl shouldReceive: @selector(times)
			   andReturn: [[ [Time morning], [Time evening]]]];
    }];
}

