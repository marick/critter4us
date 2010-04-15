@import <Critter4Us/view/DateTimeEditingControl.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _DateTimeEditingControlTest : ScenarioTestCase
{
  
}

- (void)setUp
{
  sut = [[DateTimeEditingControl alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardOutlets: ['target']];

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

-(void) test_target_will_be_informed_of_cancel
{
  [scenario
    during: function() {
      [sut setTarget: sut.target];
      [sut.cancelButton performClick: UnusedArgument]
    }
  behold: function() {
      sut.target.failOnUnexpectedSelector = YES;
      [sut.target shouldReceive: @selector(forgetEditingTimeslice:)
                           with: sut];
   }];
}


-(void) test_target_will_be_informed_of_expected_change
{
  [scenario
    during: function() {
      [sut setTarget: sut.target];
      [sut.changeButton performClick: UnusedArgument]
    }
  behold: function() {
      [sut.target shouldReceive: @selector(newTimesliceReady:)
                           with: sut];
   }];
}

@end	
