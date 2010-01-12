@import <Critter4Us/view/Spinner.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation SpinnerTest : ScenarioTestCase
{
  Advisor sut;
}

- (void) setUp
{
  sut = [[Spinner alloc] initHeadless];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutCreates: ['spinnerView', 'superView']];
}

- (void) test_responds_to_busy_notification_by_spinning
{
  [scenario
    during: function() {
      [self sendNotification: BusyNews]; 
    }
  behold: function() { 
      [sut.superView shouldReceive: @selector(addSubview:positioned:relativeTo:)
                              with: [sut.spinnerView, CPWindowAbove, nil]];
    }];
}

- (void) test_responds_available_notification_by_stopping_spinning
{
  [scenario
    during: function() {
      [self sendNotification: AvailableNews]; 
    }
  behold: function() { 
      [sut.spinnerView shouldReceive: @selector(removeFromSuperview)];
    }];
}
