@import <Critter4Us/persistence/Future.j>
@import "ScenarioTestCase.j"

@implementation FutureTest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [[Future alloc] initWithRoute: "some route" notificationName: "some notification"];

  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutWillBeGiven: ['network', 'notificationCenter']];
}

- (void) test_sending_request_registers_for_callbacks_and_becomes_busy
{
  [scenario
    during: function() { 
      [sut sendAsynchronousGetTo: sut.network];
    }
  behold: function() { 
      [sut.network shouldReceive: @selector(sendGetAsynchronouslyTo:delegate:)
                            with: ["some route", sut]];
      [self listenersShouldReceiveNotification: BusyNews];
    }];
}

- (void) test_receives_data_announces_it
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


- (void) test_sending_post_registers_for_callbacks_and_becomes_busy
{
  [scenario
    during: function() { 
      [sut sendAsynchronousPostTo: sut.network content: 'content'];
    }
  behold: function() { 
      [sut.network shouldReceive: @selector(POSTFormDataAsynchronouslyTo:withContent:delegate:)
                            with: ['some route', 'content', sut]];
      [self listenersShouldReceiveNotification: BusyNews];
    }];
}

@end
