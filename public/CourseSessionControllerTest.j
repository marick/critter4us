@import "CourseSessionController.j"
@import "ScenarioTestCase.j"

@implementation CourseSessionControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[CourseSessionController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['courseField', 'instructorField',
                                        'dateField', 'morningButton']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}

- (void)testClickingButtonNotifiesListenersOfEvent
{
  [scenario 
   during: function() {
      [sut sessionReady: sut.okButton];
    }
  behold: function() {
      [self listenersWillReceiveNotification: CourseSessionDescribedNews];
    }
   ];
}

- (void)testClickingButtonCausesExclusionsToBeRetrievedAndNotified
{
  [scenario
   during: function() {
      [sut sessionReady: sut.okButton];
    }
  behold: function() {
      [sut.dateField shouldReceive:@selector(stringValue)
                         andReturn:@"some date"];
      [sut.persistentStore shouldReceive: @selector(exclusionsForDate:)
                           with: [@"some date"]
                           andReturn: @"some exclusions"];
      [self listenersWillReceiveNotification: "exclusions" containingObject: "some exclusions"];
    }
   ];
}

-(void)testCanRespondWithSessionData
{
  var notifier = [[Mock alloc] init];
  [scenario
   during: function() {
      [self userBeginsWithSomeValues];
      [self object: notifier notifiesUniverseOfNeed: NeedForSessionDataNews];
    }
  behold: function() {
      [notifier shouldReceive: @selector(courseSession:) 
       with: function(session) {
	  [self assert: "some course" equals: session['course']];
	  [self assert: "some instructor" equals: session['instructor']];
	  [self assert: "some date" equals: session['date']];
	  [self assert: YES equals: session['isMorning']];
	  return YES;
	}];
    }
   ];
}

-(void) userBeginsWithSomeValues
{
  [sut.courseField shouldReceive:@selector(stringValue)
                       andReturn:"some course"];

  [sut.instructorField shouldReceive:@selector(stringValue)
                       andReturn:"some instructor"];

  [sut.dateField shouldReceive:@selector(stringValue)
                       andReturn:"some date"];

  [sut.morningButton shouldReceive:@selector(state)
                       andReturn:CPOnState];

  // TODO: I would rather leave this in, but it should be commented out 
  // until mocks can take default values.
  // [sut sessionReady: sut.goButton];
}

-(void) object: (CPObject)anObject notifiesUniverseOfNeed: aNotificationName
{
  [NotificationCenter postNotificationName:aNotificationName
                                    object:anObject];
}

@end
