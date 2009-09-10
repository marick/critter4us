@import <Critter4Us/page-for-making-reservations/ReservationDataControllerPMR.j>
@import "ScenarioTestCase.j"

@implementation ReservationDataControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ReservationDataControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['courseField', 'instructorField',
                                        'dateField',
                                        'morningButton', 'afternoonButton',
                                        'beginButton', 'restartButton',
                                        'reserveButton',
                                        'linkToPreviousResults']];
}

- (void)testNotifiesListenersWhenReservingStarts
{
  [scenario
    during: function() {
      [sut beginReserving: nil];
    }
  behold: function() {
      [self listenersWillReceiveNotification: ReservationDataAvailable];
    }
   ]   
}


- (void)testDisables
{
  [scenario
    previousAction: function() {
      [sut.courseField setEnabled: YES];
      [sut.instructorField setEnabled: YES];
      [sut.dateField setEnabled: YES];
      [sut.morningButton setEnabled: YES];
      [sut.afternoonButton setEnabled: YES];
      [sut.beginButton setEnabled: YES];
    }
    testAction: function() {
      [sut disable];
    }
  andSo: function() {
      [self assert: NO equals: [sut.courseField enabled]];
      [self assert: NO equals: [sut.instructorField enabled]];
      [self assert: NO equals: [sut.dateField enabled]];
      [self assert: NO equals: [sut.morningButton enabled]];
      [self assert: NO equals: [sut.afternoonButton enabled]];
      [self assert: NO equals: [sut.beginButton enabled]];
    }
   ];
}

@end
