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
                                        'previousResultsView', 'linkToPreviousResults',
                                        'linkToPreviousResults',
                                        'dateGatheringView', 'dateDisplayingView',
                                        'dateTimeSummary',
                                        'dateTimeEditingPanelController',
                                        'dateTimeEditingControl'
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



- (void) testDisplayedDateAndTimeWorksForMorning
{
  [scenario
    previousAction: function() {
      [sut.dateField setStringValue: '2010-12-02'];
      [sut.morningButton setState: CPOnState];
      [sut.afternoonButton setState: CPOffState];
    }
    testAction: function() {
      [sut prepareToFinishReservation];
    }
  andSo: function() {
      [self assert: "on the morning of 2010-12-02."
            equals: [sut.dateTimeSummary stringValue]];
    }
   ];
}

- (void) testDisplayedDateAndTimeWorksForAfternoon
{
  [scenario
    previousAction: function() {
      [sut.dateField setStringValue: '2012-01-12'];
      [sut.morningButton setState: CPOffState];
      [sut.afternoonButton setState: CPOnState];
    }
    testAction: function() {
      [sut prepareToFinishReservation];
    }
  andSo: function() {
      [self assert: "on the afternoon of 2012-01-12."
            equals: [sut.dateTimeSummary stringValue]];
    }
   ];
}

- (void) testPreparingCompletionHidesLinkToPreviousReservation
  // because it's on top of buttons
{
  [scenario
    previousAction: function() {
      [sut.previousResultsView setHidden: NO];
    }
    testAction: function() {
      [sut prepareToFinishReservation];
    }
  andSo: function() {
      [self assert: YES equals: [sut.previousResultsView hidden] ];
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

-(void)testCanReturn
{
  [scenario
   previousAction: function() { 
      [sut.courseField setStringValue: "some course"];
      [sut.instructorField setStringValue: "some instructor"];
      [sut.dateField setStringValue: "some date"];
      [sut.morningButton setState:CPOnState];
    }
   testAction: function() {
      return [sut data];
    }
  andSo: function() {
      var dict = scenario.result;
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
      [sut.previousResultsView shouldReceive: @selector(setHidden:)
                                          with: NO];
    }  
   ];
}

-(void)testCanReturnToBeginningOfReservationWorkflow
{
  [scenario
    previousAction: function() {
      [sut.dateGatheringView setHidden: YES];
      [sut.dateDisplayingView setHidden: NO];

      [sut.restartButton setHidden: NO];
      [sut.reserveButton setHidden: NO];
    }
    testAction: function() {
      [sut beginningOfReservationWorkflow];
    }
  andSo: function() {
      [self assert: NO equals: [sut.dateGatheringView hidden] ];
      [self assert: YES equals: [sut.dateDisplayingView hidden] ];

      [self assert: YES equals: [sut.restartButton hidden] ];
      [self assert: YES equals: [sut.reserveButton hidden] ];
    }
   ];
}


-(void)testBeToldValuesToEdit
{
  var data = {'course' : 'the course',
              'instructor' : 'the instructor',
              'date' : 'the date',
              'time' : [Time morning]};
  [scenario
    during: function() {
      [sut setNewValuesFrom: [CPDictionary dictionaryWithJSObject: data]];
    }
  behold: function() {
      [sut.courseField shouldReceive: @selector(setStringValue:) with: 'the course'];
      [sut.instructorField shouldReceive: @selector(setStringValue:) with: 'the instructor'];
      [sut.dateField shouldReceive: @selector(setStringValue:) with: 'the date'];
      [sut.morningButton shouldReceive: @selector(setState:) with: CPOnState];
      [sut.dateTimeSummary shouldReceive: @selector(setStringValue:)];
    }
   ];
}

-(void)testBeToldValuesToEdit__withAfternoon
{
  var data = {'time' : [Time afternoon]};
  [scenario
    during: function() {
      [sut setNewValuesFrom: [CPDictionary dictionaryWithJSObject: data]];
    }
  behold: function() {
      [sut.morningButton shouldReceive: @selector(setState:) with: CPOffState];
    }
   ];
}

// Popping up a date/time editing panel and handling what it tells us.

- (void) testDateAndTimeEditingButtonCausesPanelToBecomeVisible
{
  [scenario
  during: function() {
      [sut startDestructivelyEditingDateTime: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingPanelController shouldReceive:@selector(appear)];
    }
   ];

}

- (void) testDateAndTimeEditingPanelIsInitializedWithCurrentValues
{
  [scenario
    previousAction: function() {
      [sut.dateField setStringValue: "a value"];
      [sut.morningButton setState: "a bogus state"];
    }
  during: function() {
      [sut startDestructivelyEditingDateTime: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingControl shouldReceive: @selector(setDate:morningState:)
                                           with: ["a value", "a bogus state"]];
    }
   ];

}

- (void) testDateAndTimeCancelingCausesPanelToBecomeInvisible
{
  [scenario
  during: function() {
      [sut forgetEditingDateTime: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingPanelController shouldReceive:@selector(disappear)];
    }
   ];
}


- (void) test__andSoDoesAccepting
{
  [scenario
  during: function() {
      [sut newDateTimeValuesReady: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingPanelController shouldReceive:@selector(disappear)];
    }
   ];
}


- (void) testChoosingANewDateAndTimeFiresANotification
{
  [scenario
    during: function() {
      [sut newDateTimeValuesReady: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingControl shouldReceive:@selector(date)
                                      andReturn: '2009-12-10'];
      [sut.dateTimeEditingControl shouldReceive:@selector(morningState)
                                      andReturn: CPOffState];
      
      [self listenersWillReceiveNotification: DateTimeForCurrentReservationChangedNews
                                checkingWith: function(notification) {
          var dict = [notification object];
          [self assert: '2009-12-10' equals: [dict valueForKey: 'date']];
          [self assert: [Time afternoon] equals: [dict valueForKey: 'time']];
          return YES;
        }];
    }
   ];
}

- (void) testChoosingANewDateAndTimeUpdatesValuesDisplayedOnReservationView
{
  [scenario
    during: function() {
      [sut newDateTimeValuesReady: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingControl shouldReceive:@selector(date)
                                      andReturn: '2009-12-10'];
      [sut.dateTimeEditingControl shouldReceive:@selector(morningState)
                                      andReturn: CPOffState];
      
      [sut.dateField shouldReceive: @selector(setStringValue:)
                              with: '2009-12-10'];
      [sut.morningButton shouldReceive: @selector(setState:)
                                  with: CPOffState];

      [sut.dateTimeSummary shouldReceive: @selector(setStringValue:)];
    }
   ];
  
}
@end
