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
                                                     'dateField', 'morningButton',
                                                     'beginButton', 'restartButton', 'reserveButton']];
}

- (void) testCourseSessionInputFieldsCanBeFrozen
{
  [scenario
   previousAction: function() {
      [sut.courseField setEnabled: YES];
      [sut.instructorField setEnabled: YES];
      [sut.dateField setEnabled: YES];
      [sut.morningButton setEnabled: YES];
    }
  testAction: function() {
      [sut freezeCourseSessionInput];
    }
  andSo: function() {
      [self assertFalse: [sut.courseField hidden]];
      [self assertFalse: [sut.instructorField hidden]];
      [self assertFalse: [sut.dateField hidden]];
      [self assertFalse: [sut.morningButton hidden]];
    }];
}


- (void) testFreezingDataInputAlsoReplacesButtons
{
  [scenario
   previousAction: function() {
      [sut.beginButton setHidden: NO];
      [sut.restartButton setHidden: YES];
      [sut.reserveButton setHidden: YES];
    }
  testAction: function() {
      [sut freezeCourseSessionInput];
    }
  andSo: function() {
      [self assertTrue: [sut.beginButton hidden]];
      [self assertFalse: [sut.restartButton hidden]];
      [self assertFalse: [sut.reserveButton hidden]];
    }];
}

- (void)testCommittingToParticularCourseSessionNotifiesListenersOfEvent
{
  [scenario 
   during: function() {
      [sut commitToParticularCourseSession: sut.beginButton];
    }
  behold: function() {
      [self listenersWillReceiveNotification: ReservationDataCollectedNews];
    }
   ];
}

-(void)testCanSpillSessionData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
   previousAction: function() { 
      [self userBeginsWithSomeValues];
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

-(void)testCanSetSessionDataArtificially
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
   testAction: function() {
      settings = {'course':'the course',
		  'instructor': 'the instructor',
		  'date' : 'the date',
		  'time' : [Time afternoon] };
      [sut setIt: settings]
      [sut spillIt: dict];
    }
  andSo: function() {
      [self assert: "the course" equals: [dict valueForKey: 'course']];
      [self assert: "the instructor" equals: [dict valueForKey: 'instructor']];
      [self assert: "the date" equals: [dict valueForKey:'date']];
      [self assert: [Time afternoon] equals: [dict valueForKey:'time']];
    }];
}

- (void)testReserveButtonSendsANotification
{
  [scenario
   during: function() {
      [sut makeReservation: sut.reserveButton];
    }
   behold: function() {
      [self listenersWillReceiveNotification: GroupingsDataCollectedNews];
    }];
}

- (void)testAllowChoiceOfNextParticularCourseSession
{
  [scenario
   during: function() {
      [sut allowUserToChooseParticularCourseSession];
    }
   behold: function() {
      [sut.courseField shouldReceive:@selector(setEnabled:) with:YES];
      [sut.instructorField shouldReceive:@selector(setEnabled:) with:YES];
      [sut.dateField shouldReceive:@selector(setEnabled:) with:YES];
      [sut.morningButton shouldReceive:@selector(setEnabled:) with:YES];

      [sut.beginButton shouldReceive:@selector(setHidden:) with:NO];
      [sut.reserveButton shouldReceive:@selector(setHidden:) with:YES];
      [sut.restartButton shouldReceive:@selector(setHidden:) with:YES];
    }];
}

- (void)testLinkToAReservationCanBeOffered
{
  [scenario
   during: function() {
      [sut offerReservationView: 55];
    }
   behold: function() {
      [sut.linkToPreviousResults shouldReceive:@selector(setHidden:) 
                                          with: NO];
      [sut.linkToPreviousResults shouldReceive:@selector(loadHTMLString:baseURL:) 
       with: [function(arg) {
	    return arg.match(/\/reservation\/55/)
	  }, function(x) { return YES }] // TODO: define "any" somewhere.
       ]; 
    }];
}


-(void) userBeginsWithSomeValues
{
  [sut.courseField setStringValue: "some course"];
  [sut.instructorField setStringValue: "some instructor"];
  [sut.dateField setStringValue: "some date"];
  [sut.morningButton setState:CPOnState];
}


@end
