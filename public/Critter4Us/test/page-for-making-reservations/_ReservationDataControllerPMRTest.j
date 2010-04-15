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
  [scenario sutHasUpwardCollaborators: ['courseField', 'instructorField', 'timesliceControl',
   				        'timesliceSummary',
                                        'beginButton', 
                                        'reserveButton',
                                        'previousResultsView', 'copyButton',
                                        'linkToPreviousResults',
    				        'majorModificationView', 'dateGatheringView',
                                        'timesliceChangingPopupController',
                                        'timesliceChangingControl'
                                        ]];
}



- (void)test_notifies_listeners_that_user_wants_to_reserve_a_particular_Timeslice
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
  			      lastDate: '2009-12-11'
  				 times: [ [Time morning], [Time evening] ]];

  [scenario
    previously: function() {
      [sut.timesliceControl setTimeslice: timeslice];
    }
  during: function() {
      [sut beginReserving: UnusedArgument];
    }
  behold: function() {
      [sut.timesliceControl shouldReceive: @selector(timeslice)
				andReturn: timeslice];
      [self listenersWillReceiveNotification: UserHasChosenTimeslice
			    containingObject: timeslice];
    }];
}



- (void) test_timeslice_summary_is_updated_when_needed
{
  var preparing = [Timeslice degenerateDate: "preparing"];
  var setting = [Timeslice degenerateDate: "setting"];
  var dictionarying = [Timeslice degenerateDate: "dictionarying"];

  [scenario
    during: function() {
      [sut.timesliceControl setTimeslice: preparing];
      [sut prepareToFinishReservation];

      [sut newTimesliceReady: UnusedArgument];

      [sut.timesliceControl setTimeslice: dictionarying];
      [sut setNewValuesFrom: [CPDictionary dictionaryWithJSObject: {'timeslice':dictionarying}]];
    }
  behold: function() { 
      [sut.timesliceSummary shouldReceive: @selector(summarize:)
				     with: preparing];
      [sut.timesliceChangingControl shouldReceive: @selector(timeslice)
				      andReturn: setting];
      [sut.timesliceSummary shouldReceive: @selector(summarize:)
				     with: setting];
      [sut.timesliceSummary shouldReceive: @selector(summarize:)
				     with: dictionarying];
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
  var timeslice = [Timeslice firstDate: 'some first date'
  			      lastDate: 'some last date'
  				 times: [ [Time evening] ]];

  [scenario
   previously: function() { 
      [sut.courseField setStringValue: "some course"];
      [sut.instructorField setStringValue: "some instructor"];
      [sut.timesliceControl setTimeslice: timeslice ];
    }
   testAction: function() {
      return [sut data];
    }
  andSo: function() {
      var dict = scenario.result;
      [self assert: "some course" equals: [dict valueForKey: 'course']];
      [self assert: "some instructor" equals: [dict valueForKey: 'instructor']];
      [self assert: timeslice equals: [dict valueForKey:'timeslice']];
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
      [sut.timesliceSummary setHidden: NO];

      [sut.majorModificationView setHidden: NO];
      [sut.reserveButton setHidden: NO];
    }
    testAction: function() {
      [sut beginningOfReservationWorkflow];
    }
  andSo: function() {
      [self assert: NO equals: [sut.dateGatheringView hidden] ];
      [self assert: YES equals: [sut.timesliceSummary hidden] ];

      [self assert: YES equals: [sut.majorModificationView hidden] ];
      [self assert: YES equals: [sut.reserveButton hidden] ];
    }
   ];
}


-(void) testBeToldValuesToEdit
{
  var timeslice = [Timeslice firstDate: 'the first date'
			      lastDate: 'the last date'
				 times: [[Time morning]]];
  var data = {'course' : 'the course',
              'instructor' : 'the instructor',
	      'timeslice' :  timeslice };
  [scenario
    during: function() {
      [sut setNewValuesFrom: [CPDictionary dictionaryWithJSObject: data]];
    }
  behold: function() {
      [sut.courseField shouldReceive: @selector(setStringValue:) with: 'the course'];
      [sut.instructorField shouldReceive: @selector(setStringValue:) with: 'the instructor'];
      [sut.timesliceControl shouldReceive: @selector(setTimeslice:) with: timeslice];
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
      [sut.timesliceChangingPopupController shouldReceive:@selector(appear)];
    }
   ];

}

- (void) test_date_and_time_editing_panel_is_initialized_with_current_values
{
  var timeslice = [Timeslice firstDate: 'a first value'
  			      lastDate: 'a last value'
  				 times: [ [Time afternoon] ]];

  [scenario
    during: function() {
      [sut startDestructivelyEditingTimeslice: UnusedArgument];
    }
  behold: function() {
      [sut.timesliceControl shouldReceive: @selector(timeslice)
				andReturn: timeslice];
      [sut.timesliceChangingControl shouldReceive: @selector(setTimeslice:)
					   with: timeslice];
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
      [sut.timesliceChangingPopupController shouldReceive:@selector(disappear)];
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
      [sut.timesliceChangingPopupController shouldReceive:@selector(disappear)];

      [sut.timesliceChangingControl shouldReceive:@selector(timeslice)
                                      andReturn: timeslice];

      [self listenersWillReceiveNotification: TimesliceForCurrentReservationChangedNews
			    containingObject: timeslice];
    }
   ];
}


// TODO: This test will shortly be redundant.
- (void) test_choosing_a_new_timeslice_updates_values_displayed_on_reservation_view
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-11'
				 times: [ [Time afternoon] ]];
  sut.timesliceControl = [[TimesliceControl alloc] initAtX: 0 y: 0];
  [scenario
    during: function() {
      [sut newTimesliceReady: UnusedArgument];
    }
  behold: function() {
      [sut.timesliceChangingControl shouldReceive:@selector(timeslice)
                                      andReturn: timeslice];
      [sut.timesliceSummary shouldReceive:@selector(summarize:)
				     with: timeslice];
    }
   ];
}

@end
