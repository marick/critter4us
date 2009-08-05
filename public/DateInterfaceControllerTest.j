@import "DateInterfaceController.j"
@import "ScenarioTestCase.j"

@implementation DateInterfaceControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[DateInterfaceController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['textField']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}


- (void)testPickingDateNotifiesListenersOfEvent
{
  [scenario 
   during: function() {
      [self selectDate: "2009-09-03"]
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
      [self selectDate: "some date"];
    }
  behold: function() {
      [sut.persistentStore shouldReceive: @selector(exclusionsForDate:)
                           with: [@"some date"]
                           andReturn: @"some exclusions"];
      [self listenersWillReceiveNotification: "exclusions" containingObject: "some exclusions"];
    }
   ];
}

- (void) selectDate: (CPString) aDate
{
  [sut.textField shouldReceive: @selector(stringValue) andReturn: aDate];
  [sut newDate: sut.textField];
}

@end
