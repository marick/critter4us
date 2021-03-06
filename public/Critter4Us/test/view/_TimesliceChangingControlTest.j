@import <Critter4Us/view/TimesliceChangingControl.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _TimesliceChangingControlTest : ScenarioTestCase
{
  
}

- (void)setUp
{
  sut = [[TimesliceChangingControl alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardOutlets: ['target', 'container']];

  [CPApplication sharedApplication]; // clicks only work in this context.
}

-(void) test_can_be_set_to_a_timeslice
{
  var newValue = [Timeslice firstDate: '2009-01-01'
			     lastDate: '2009-02-02'
				times: [ [Time morning], [Time evening] ] ];
  [scenario
    previously: function() {
      [sut.timesliceControl setTimeslice: [Timeslice degenerateDate: "BOGUS"]];
    }
    testAction: function() {
      [sut setTimeslice: newValue];
    }
    andSo: function() {
      [self assert: [sut.timesliceControl timeslice]
	    equals: newValue];
   }];
}

- (void) test_responds_to_user_desires_to_change_timeslice
{
  var oldTimeslice = [Timeslice firstDate: '2009-01-01'
				 lastDate: '2009-02-02'
				    times: [ [Time morning], [Time evening] ] ];
  [scenario 
    during: function() { 
      [self sendNotification: UserWantsToReplaceTimeslice
		  withObject: oldTimeslice];
    }
  behold: function() {
      [sut.timeliceControl shouldReceive: @selector(setTimeslice:)
				    with: oldTimeslice];
      [sut.container shouldReceive: @selector(appear)];
    }];
}

-(void) test_canceling_hides_popup
{
  [scenario
    during: function() {
      [sut setTarget: sut.target];
      [sut.cancelButton performClick: UnusedArgument]
    }
  behold: function() {
      sut.container.failOnUnexpectedSelector = YES;
      [sut.container shouldReceive: @selector(disappear)];
   }];
}


-(void) test_target_will_be_informed_of_expected_change
{
  var timeslice = [Timeslice degenerateDate: "2009-10-01"
				       time: [Time morning]];
  [scenario
    previously: function() {
      [sut.timesliceControl setTimeslice: timeslice];
    }
    during: function() {
      [sut setTarget: sut.target];
      [sut.changeButton performClick: UnusedArgument]
    }
  behold: function() {
      [sut.target shouldReceive: @selector(newTimesliceReady:)
                           with: timeslice];
      sut.container.failOnUnexpectedSelector = YES;
      [sut.container shouldReceive: @selector(disappear)];
   }];
}

@end	
