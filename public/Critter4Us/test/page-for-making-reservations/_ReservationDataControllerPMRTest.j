@import <Critter4Us/page-for-making-reservations/ReservationDataControllerPMR.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>
@import <Critter4Us/view/TimeControl.j>

@implementation _ReservationDataControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ReservationDataControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['courseField', 'instructorField',
					'dateControl', 'timeControl',
                                        'beginButton', 
                                        'reserveButton',
                                        'previousResultsView', 'copyButton',
                                        'linkToPreviousResults',
    				        'majorModificationView', 'dateGatheringView', 'dateDisplayingView',
                                        'dateTimeSummary',
                                        'dateTimeEditingPanelController',
                                        'dateTimeEditingControl'
                                        ]];
}

- (void) test_timeslices_are_retrieved_from_controls
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
  			      lastDate: '2009-12-11'
  				 times: [ [Time morning], [Time evening] ]];

  [scenario
    during: function() {
      [sut timeslice];
    }
  behold: function() {
      [sut.dateControl shouldReceive: @selector(firstDate)
			      andReturn: '2009-12-10'];
      [sut.dateControl shouldReceive: @selector(lastDate)
			     andReturn: '2009-12-11'];
      [sut.timeControl shouldReceive: @selector(times)
			   andReturn: [[ [Time morning], [Time evening]]]];
    }];
}


- (void) test_timeslices_are_stored_in_controls
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
  			      lastDate: '2009-12-11'
  				 times: [ [Time morning], [Time evening] ]];

  [scenario
    during: function() {
      [sut setTimeslice: timeslice];
    }
  behold: function() {
      [sut.dateControl shouldReceive: @selector(setFirst:last:)
				with: ['2009-12-10', '2009-12-11']];
      [sut.timeControl shouldReceive: @selector(setTimes:)
				with: [timeslice.times]];
    }];
}


- (void)test_notifies_listeners_that_user_wants_to_reserve_a_particular_Timeslice
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
  			      lastDate: '2009-12-11'
  				 times: [ [Time morning], [Time evening] ]];

  [scenario
    previously: function() {
      [sut setTimeslice: timeslice];
    }
  during: function() {
      [sut beginReserving: UnusedArgument];
    }
  behold: function() {
      [sut.dateControl shouldReceive: @selector(firstDate)
			      andReturn: timeslice.firstDate];
      [sut.dateControl shouldReceive: @selector(lastDate)
			     andReturn: timeslice.lastDate];
      [sut.timeControl shouldReceive: @selector(times)
			     andReturn: timeslice.times];
      [self listenersWillReceiveNotification: UserHasChosenTimeslice
			    containingObject: timeslice];
    }];
}

- (void) test_displayed_timeslice_works
{
  [scenario
    during: function() {
      [sut prepareToFinishReservation];
    }
  behold: function() { 
      [sut.dateControl shouldReceive: @selector(firstDate)
			      andReturn: '2009-12-10'];
      [sut.dateControl shouldReceive: @selector(lastDate)
			     andReturn: '2009-12-10'];
      [sut.timeControl shouldReceive: @selector(times)
			     andReturn: [ [Time morning] ]];
    }
  andSo: function() {
      [self assert: "on the morning of 2009-12-10."
            equals: [sut.dateTimeSummary stringValue]];
    }
   ];
}

- (void) testPreparingCompletionHidesLinkToPreviousReservation
  // because it's on top of buttons
{
  [scenario
    previously: function() {
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

-(void) test_can_return_values_of_controls_as_dictionary
{
  [scenario
   previously: function() { 
      [sut.courseField setStringValue: "some course"];
      [sut.instructorField setStringValue: "some instructor"];
      [sut.timeControl setTimes: [ [Time evening] ]];
    }
   during: function() {
      return [sut data];
    }
  behold: function() { 
      [sut.dateControl shouldReceive: @selector(firstDate)
			   andReturn: "some first date"];
      [sut.dateControl shouldReceive: @selector(lastDate)
			   andReturn: "some last date"];
    }
  andSo: function() {
      var dict = scenario.result;
      [self assert: "some course" equals: [dict valueForKey: 'course']];
      [self assert: "some instructor" equals: [dict valueForKey: 'instructor']];
      [self assert: [Timeslice firstDate: "some first date" 
				lastDate: "some last date"
				   times: [ [Time evening] ]]
	    equals: [dict valueForKey:'timeslice']];
    }];
}

-(void) test_can_be_told_to_offer_a_link_to_previous_reservation
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

-(void) test_offering_a_link_to_previous_reservation_also_stashes_ID_in_copy_button
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



-(void) testCanReturnToBeginningOfReservationWorkflow
{
  [scenario
    previously: function() {
      [sut.dateGatheringView setHidden: YES];
      [sut.dateDisplayingView setHidden: NO];

      [sut.majorModificationView setHidden: NO];
      [sut.reserveButton setHidden: NO];
    }
    testAction: function() {
      [sut beginningOfReservationWorkflow];
    }
  andSo: function() {
      [self assert: NO equals: [sut.dateGatheringView hidden] ];
      [self assert: YES equals: [sut.dateDisplayingView hidden] ];

      [self assert: YES equals: [sut.majorModificationView hidden] ];
      [self assert: YES equals: [sut.reserveButton hidden] ];
    }
   ];
}


-(void) testBeToldValuesToEdit
{
  var data = {'course' : 'the course',
              'instructor' : 'the instructor',
	      'timeslice' : [Timeslice firstDate: 'the first date'
					lastDate: 'the last date'
					   times: [[Time morning]]] };
  [scenario
    during: function() {
      [sut setNewValuesFrom: [CPDictionary dictionaryWithJSObject: data]];
    }
  behold: function() {
      [sut.courseField shouldReceive: @selector(setStringValue:) with: 'the course'];
      [sut.instructorField shouldReceive: @selector(setStringValue:) with: 'the instructor'];
      [sut.dateControl shouldReceive: @selector(setFirst:last:) 
				with: ['the first date', 'the last date']];
      [sut.dateTimeSummary shouldReceive: @selector(setStringValue:)];
      [sut.timeControl shouldReceive: @selector(setTimes:) with: [[[Time morning]]]];
    }
   ];
}


// Popping up a date/time editing panel and handling what it tells us.

- (void) testDateAndTimeEditingButtonCausesPanelToBecomeVisible
{
  [scenario
  during: function() {
      [sut startDestructivelyEditingTimeslice: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingPanelController shouldReceive:@selector(appear)];
    }
   ];

}

- (void) test_date_and_time_editing_panel_is_initialized_with_current_values
{
  [scenario
    during: function() {
      [sut startDestructivelyEditingTimeslice: UnusedArgument];
    }
  behold: function() {
      [sut.dateControl shouldReceive: @selector(firstDate)
			   andReturn: "a first value"];
      [sut.dateControl shouldReceive: @selector(lastDate)
			   andReturn: "a last value"];
      [sut.timeControl shouldReceive: @selector(times)
			   andReturn: [ [Time afternoon] ]];
      [sut.dateTimeEditingControl shouldReceive: @selector(setTimeslice:)
					   with: [Timeslice firstDate: "a first value"
							     lastDate: "a last value"
								times: [ [Time afternoon] ] ]];
    }
   ];
}

- (void) testDateAndTimeCancelingCausesPanelToBecomeInvisible
{
  [scenario
  during: function() {
      [sut forgetEditingTimeslice: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingPanelController shouldReceive:@selector(disappear)];
    }
   ];
}



- (void) test_choosing_a_new_timeslice_makes_panel_disappear_and_fires_notification
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-10'
				 times: [ [Time afternoon] ]];
  [scenario
    during: function() {
      [sut newTimesliceReady: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingPanelController shouldReceive:@selector(disappear)];

      [sut.dateTimeEditingControl shouldReceive:@selector(timeslice)
                                      andReturn: timeslice];
      
      [self listenersWillReceiveNotification: TimesliceForCurrentReservationChangedNews
			    containingObject: timeslice];
    }
   ];
}

- (void) test_choosing_a_new_timeslice_updates_values_displayed_on_reservation_view
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-11'
				 times: [ [Time afternoon] ]];
  sut.dateControl = [[DualDateControl alloc] initAtX: 0 y: 0];
  [scenario
    during: function() {
      [sut newTimesliceReady: UnusedArgument];
    }
  behold: function() {
      [sut.dateTimeEditingControl shouldReceive:@selector(timeslice)
                                      andReturn: timeslice];
    }
  andSo: function() {
      [self assert: "on the afternoons of 2009-12-10 through 2009-12-11."
            equals: [sut.dateTimeSummary stringValue]];
    }
   ];
}

@end
