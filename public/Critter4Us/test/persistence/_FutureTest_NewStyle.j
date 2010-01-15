@import <Critter4Us/persistence/Future.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _FutureTest_NewStyle : ScenarioTestCase
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


@end
