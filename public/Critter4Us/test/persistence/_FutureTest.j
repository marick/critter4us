@import <Critter4Us/persistence/Future.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _FutureTest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [Future alloc] 

  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['network', 'converter']];
  [sut initWithNotificationName: "notification name"
                      converter: sut.converter]
}


- (void) test_getting_from_network_registers_for_callback_and_becomes_busy
{
  [scenario
    during: function() { 
      [sut get: "some route" from: sut.network];
    }
  behold: function() { 
      [sut.network shouldReceive: @selector(sendGetAsynchronouslyTo:delegate:)
                            with: ["some route", sut]];
      [self listenersShouldReceiveNotification: BusyNews];
    }];
}

- (void) test_posting_to_network_registers_for_callback_and_becomes_busy
{
  [scenario
    during: function() { 
      [sut postContent: "some content" toRoute: "some route" on: sut.network];
    }
  behold: function() { 
      [sut.network shouldReceive: @selector(POSTFormDataAsynchronouslyTo:withContent:delegate:)
                            with: ['some route', 'some content', sut]];
      [self listenersShouldReceiveNotification: BusyNews];
    }];
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
