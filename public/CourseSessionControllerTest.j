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


- (void)testPickingDateNotifiesListenersOfEvent
{
  [scenario 
   during: function() {
      [self selectSessionForDate: "2009-09-03"]
    }
  behold: function() {
      [self listenersWillReceiveNotification: "date chosen" containingObject: "2009-09-03"];
    }
   ];
}


- (void)testPickingDateCausesExclusionsToBeRetrievedAndNotified
{
  [scenario
   during: function() {
      [self selectSessionForDate: "some date"];
    }
  behold: function() {
      [sut.persistentStore shouldReceive: @selector(exclusionsForDate:)
                           with: [@"some date"]
                           andReturn: @"some exclusions"];
      [self listenersWillReceiveNotification: "exclusions" containingObject: "some exclusions"];
    }
   ];
}

- (void) selectSessionForDate: (CPString) aDate
{
  [sut.dateField shouldReceive: @selector(stringValue) andReturn: aDate];
  [sut sessionReady: 'irrelevant'];
}

@end
