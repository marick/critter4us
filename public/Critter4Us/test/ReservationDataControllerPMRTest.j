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
                                        'newWorkupHerdButton',
                                        'linkToPreviousResults'
                                        ]];
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
      [sut.newWorkupHerdButton setHidden: YES];
    }
    testAction: function() {
      [sut prepareToFinishReservation];
    }
  andSo: function() {
      [self assert: YES equals: [sut.beginButton hidden] ];
      [self assert: NO equals: [sut.restartButton hidden] ];
      [self assert: NO equals: [sut.reserveButton hidden] ];
      [self assert: NO equals: [sut.newWorkupHerdButton hidden] ];
    }
   ];
}

- (void) testPreparingCompletionHidesLinkToPreviousReservation
  // because it's on top of buttons
{
  [scenario
    previousAction: function() {
      [sut.linkToPreviousResults setHidden: NO];
    }
    testAction: function() {
      [sut prepareToFinishReservation];
    }
  andSo: function() {
      [self assert: YES equals: [sut.linkToPreviousResults hidden] ];
    }
   ];
}

- (void)testCompletionButtonClickJustSendsANotification
{
  [scenario
   during: function() {
      [sut makeReservation: 'ignored'];
    }
   behold: function() {
      [self listenersWillReceiveNotification: TimeToReserveNews];
    }];
}

-(void)testCanSpillSessionData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
   previousAction: function() { 
      [sut.courseField setStringValue: "some course"];
      [sut.instructorField setStringValue: "some instructor"];
      [sut.dateField setStringValue: "some date"];
      [sut.morningButton setState:CPOnState];
    }
   testAction: function() {
      [sut spillIt: dict];
    }
  andSo: function() {
      [self assert: "some course" equals: [dict valueForKey: 'course']];
      [self assert: "some instructor" equals: [dict valueForKey: 'instructor']];
      [self assert: "some date" equals: [dict valueForKey:'date']];
      [self assert: [Time morning] equals: [dict valueForKey:'time']];
    }];
}

-(void)testCanBeToldToOfferALinkToPreviousReservation
{
  [scenario
   during: function() {
      [sut offerReservationView: '33'];
    }
    behold: function() {
      [sut.linkToPreviousResults shouldReceive: @selector(loadHTMLString:baseURL:)
       with: [function(arg) {
	    return arg.match(/\/reservation\/33/)
	  }, function(x) { return YES }] // TODO: Make this any "any".
       ]; 
      [sut.linkToPreviousResults shouldReceive: @selector(setHidden:)
                                          with: NO];
    }  
   ];
}

-(void)testCanRestart
{
  [scenario
    previousAction: function() {
      [sut.courseField setEnabled: NO];
      [sut.instructorField setEnabled: NO];
      [sut.dateField setEnabled: NO];
      [sut.morningButton setEnabled: NO];
      [sut.afternoonButton setEnabled: NO];
      [sut.beginButton setEnabled: NO];

      [sut.beginButton setHidden: YES];
      [sut.restartButton setHidden: NO];
      [sut.reserveButton setHidden: NO];
      [sut.newWorkupHerdButton setHidden: NO];
    }
    testAction: function() {
      [sut restart];
    }
  andSo: function() {
      [self assert: YES equals: [sut.courseField enabled]];
      [self assert: YES equals: [sut.instructorField enabled]];
      [self assert: YES equals: [sut.dateField enabled]];
      [self assert: YES equals: [sut.morningButton enabled]];
      [self assert: YES equals: [sut.afternoonButton enabled]];
      [self assert: YES equals: [sut.beginButton enabled]];

      [self assert: NO equals: [sut.beginButton hidden] ];
      [self assert: YES equals: [sut.restartButton hidden] ];
      [self assert: YES equals: [sut.reserveButton hidden] ];
      [self assert: YES equals: [sut.newWorkupHerdButton hidden] ];
    }
   ];
}

@end
