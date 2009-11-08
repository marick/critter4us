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
                                                     'eveningButton',
                                        'beginButton', 'restartButton',
                                        'reserveButton',
                                        'previousResultsView', 'copyButton',
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
      [sut setTime: [Time afternoon]];
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
      [sut.eveningButton setState: CPOffState];
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
      [sut.eveningButton setState: CPOffState];
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

- (void) testDisplayedDateAndTimeWorksForEvening
{
  [scenario
    previousAction: function() {
      [sut.dateField setStringValue: '2012-01-12'];
      [sut setTime: [Time evening]];
    }
    testAction: function() {
      [sut prepareToFinishReservation];
    }
  andSo: function() {
      [self assert: "on the evening of 2012-01-12."
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
      [sut setTime: [Time evening]];
    }
   testAction: function() {
      return [sut data];
    }
  andSo: function() {
      var dict = scenario.result;
      [self assert: "some course" equals: [dict valueForKey: 'course']];
      [self assert: "some instructor" equals: [dict valueForKey: 'instructor']];
      [self assert: "some date" equals: [dict valueForKey:'date']];
      [self assert: [Time evening] equals: [dict valueForKey:'time']];
    }];
}

-(void)test_can_be_told_to_offer_a_link_to_previous_reservation
{
  [scenario
   during: function() {
      [sut offerOperationsOnJustFinishedReservation: '33'];
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

-(void)test_offering_a_link_to_previous_reservation_also_stashes_ID_in_copy_button
{
  [scenario
   testAction: function() {
      [sut offerOperationsOnJustFinishedReservation: '33'];
    }
    andSo: function() {
      [self assert: '33' equals: [sut.copyButton tag]];
    }  
   ];
}

- (void) test_clicking_copy_button_sends_a_notification
{
  [scenario 
    during: function() {
      [sut copyPreviousReservation: sut.copyButton];
    }
  behold: function() {
      [sut.copyButton shouldReceive: @selector(tag)
                          andReturn: '33'];
      [self listenersShouldReceiveNotification: CopyReservationNews
                              containingObject: '33'];
    }];
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
      [sut.dateTimeSummary shouldReceive: @selector(setStringValue:)];
    }
  andSo: function() {
      [self assert: CPOnState equals: [sut.morningButton state]];
      [self assert: CPOffState equals: [sut.afternoonButton state]];
      [self assert: CPOffState equals: [sut.eveningButton state]];
    }
   ];
}

-(void)testBeToldValuesToEdit__withAfternoon
{
  var data = {'time' : [Time afternoon]};
  [scenario
    testAction: function() {
      [sut setNewValuesFrom: [CPDictionary dictionaryWithJSObject: data]];
    }
  andSo: function() {
      [self assert: CPOffState equals: [sut.morningButton state]];
      [self assert: CPOnState equals: [sut.afternoonButton state]];
      [self assert: CPOffState equals: [sut.eveningButton state]];
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
      [sut setTime: [Time afternoon]];
    }
  during: function() {
      [sut startDestructivelyEditingDateTime: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingControl shouldReceive: @selector(setDate:time:)
                                           with: ["a value", [Time afternoon]]];
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
      [sut.dateTimeEditingControl shouldReceive:@selector(time)
                                      andReturn: [Time afternoon]];
      
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
      [sut.dateTimeEditingControl shouldReceive:@selector(time)
                                      andReturn: [Time evening]];
    }
  andSo: function() {
      [self assert: "on the evening of 2009-12-10."
            equals: [sut.dateTimeSummary stringValue]];
    }
   ];
  
}
@end
