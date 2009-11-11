@import <Critter4Us/persistence/ReservationTableFuture.j>
@import "ScenarioTestCase.j"



@implementation ReservationTableFutureTest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [[ReservationTableFuture alloc] init];
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
                            with: [AllReservationsTableRoute, sut]];
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
      [self listenersShouldReceiveNotification: ReservationTableRetrievedNews
                              containingObject: "foobar"];
      [self listenersShouldReceiveNotification: AvailableNews]
    }];
}

@end
