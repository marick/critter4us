@import <Critter4Us/page-for-making-reservations/ReservationDataController.j>
@import "ScenarioTestCase.j"

@implementation ReservationDataControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ReservationDataController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['courseField', 'instructorField',
                                                     'dateField', 'morningButton',
                                                     'beginButton', 'restartButton', 'reserveButton']];
}

- (void) testCommittingToParticularCourseSessionDisablesDataFields
{
  [scenario
   previousAction: function() {
      [sut.courseField setEnabled: YES];
      [sut.instructorField setEnabled: YES];
      [sut.dateField setEnabled: YES];
      [sut.morningButton setEnabled: YES];
    }
  testAction: function() {
      [sut commitToParticularCourseSession: sut.beginButton];
    }
  andSo: function() {
      [self assertFalse: [sut.courseField hidden]];
      [self assertFalse: [sut.instructorField hidden]];
      [self assertFalse: [sut.dateField hidden]];
      [self assertFalse: [sut.morningButton hidden]];
    }];
}


- (void) testCommittingToParticularCourseSessionReplacesBeginButtonWithRestartAndReserve
{
  [scenario
   previousAction: function() {
      [sut.beginButton setHidden: NO];
      [sut.restartButton setHidden: YES];
      [sut.reserveButton setHidden: YES];
    }
  testAction: function() {
      [sut commitToParticularCourseSession: sut.beginButton];
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
      [self listenersWillReceiveNotification: CourseSessionDescribedNews];
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

- (void)testReserveButtonClickJustSendsANotification
{
  [scenario
   during: function() {
      [sut makeReservation: sut.reserveButton];
    }
   behold: function() {
      [self listenersWillReceiveNotification: ReservationRequestedNews];
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
