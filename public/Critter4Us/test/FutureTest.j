@import <Critter4Us/persistence/Future.j>
@import "ScenarioTestCase.j"

@implementation SomeRandomFuture : Future
{
}

- (CPString) route
{
  return "some route";
}

-(CPString) notification
{
  return "some notification";
}

@end

@implementation FutureTest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [[SomeRandomFuture alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutWillBeGiven: ['network']];
}

- (void) test_sending_request_registers_for_callbacks_and_becomes_busy
{
  [scenario
    during: function() { 
      [sut sendAsynchronousRequestTo: sut.network];
    }
  behold: function() { 
      [sut.network shouldReceive: @selector(sendGetAsynchronouslyTo:delegate:)
                            with: ["some route", sut]];
      [self listenersShouldReceiveNotification: BusyNews];
    }];
}

- (void) test_receives_data_and_announces_it
{
  [scenario
    previousAction: function() { 
      [sut connection: UnusedArgument didReceiveData: "foo"];
      [sut connection: UnusedArgument didReceiveData: "bar"];
    }
  during: function() {
      [sut connectionDidFinishLoading: UnusedArgument];
    }
  behold: function() {
      [self listenersShouldReceiveNotification: "some notification"
                              containingObject: "foobar"];
      [self listenersShouldReceiveNotification: AvailableNews]
    }];
}

@end
