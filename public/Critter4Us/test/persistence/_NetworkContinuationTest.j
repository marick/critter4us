@import <Critter4Us/persistence/NetworkContinuation.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _NetworkContinuationTest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [NetworkContinuation alloc] 

  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['converter']];
  [sut initWithNotificationName: "notification name"
                      converter: sut.converter]
}


- (void) test_receives_data_converts_and_announces_it
{
  [scenario
    previously: function() { 
      [sut connection: UnusedArgument didReceiveData: "foo"];
      [sut connection: UnusedArgument didReceiveData: "bar"];
    }
  during: function() {
      [sut connectionDidFinishLoading: UnusedArgument];
    }
  behold: function() {
      [sut.converter shouldReceive: @selector(convert:)
			      with: "foobar"
			 andReturn: "converted foobar"];
      [self listenersShouldReceiveNotification: "notification name"
                              containingObject: "converted foobar"];
      [self listenersShouldReceiveNotification: AvailableNews]
    }];
}



// For some reason, Firefox peppers the app with an empty data callback and 
// an empty end-of-request callback before it even sends the GET.
- (void) test_a_connection_that_finishes_with_empty_data_does_nothing
{
  [scenario
  during: function() {
      [sut connectionDidFinishLoading: UnusedArgument];
    }
  behold: function() {
      [self listenersShouldHearNo: "some notification"];
    }];
}

@end
