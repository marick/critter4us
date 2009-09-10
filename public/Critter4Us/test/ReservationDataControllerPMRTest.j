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
    previousAction: function() {
      [sut.dateField setStringValue: '2009-12-10'];
      [sut.morningButton setState: CPOffState];
    }
    during: function() {
      [sut beginReserving: UnusedArgument];
    }
  behold: function() {

      [self listenersWillReceiveNotification: ReservationDataAvailable
                                checkingWith: function(notification) {
          var dict = [notification object];
          [self assert: '2009-12-10' equals: [dict valueForKey: 'date']];
          [self assert: [Time afternoon] equals: [dict valueForKey: 'time']];
          return YES;
        }];
    }
   ]   
}


- (void)testCanBeToldToAllowNoDataChanges
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
      [sut allowNoDataChanges];
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

- (void) testCanBeToldToPrepareForCompletionOfReservation
{
  [scenario
    previousAction: function() {
      [sut.beginButton setHidden: NO];
      [sut.restartButton setHidden: YES];
      [sut.reserveButton setHidden: YES];
    }
    testAction: function() {
      [sut prepareToFinishReservation];
    }
  andSo: function() {
      [self assert: [sut.beginButton hidden] equals: YES];
      [self assert: [sut.restartButton hidden] equals: NO];
      [self assert: [sut.reserveButton hidden] equals: NO];
    }
   ];
}

@end
