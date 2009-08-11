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
                                        'dateField', 'morningButton',
					'summaryField', 
					'buildingView', 'finishedView']];
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

- (void)testClickingButtonChangesTheDisplayToMakeItInformativeYetImmutable
{
  [scenario 
   given: function() {
      [self userBeginsWithSomeValues];
    }
  during: function() {
      [sut sessionReady: sut.okButton];
    }
  behold: function() {
      [sut.buildingView shouldReceive: @selector(setHidden:) with:YES];
      [sut.finishedView shouldReceive: @selector(setHidden:) with:NO];
      [sut.summaryField shouldReceive: @selector(setStringValue:) 
       with: function(value) {
	  [self assertTrue: value.match("some instructor.*some course.*morning.*some date")
	   message: "Expected '" + value + "' to have informative content."];
	  return YES;
	}];
    }];
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

-(void)testCanSpillSessionData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
   given: function() { 
      [self userBeginsWithSomeValues];
    }
   sequence: function() {
      [sut spillIt: dict];
    }
  means: function() {
      [self assert: "some course" equals: [dict valueForKey: 'course']];
      [self assert: "some instructor" equals: [dict valueForKey: 'instructor']];
      [self assert: "some date" equals: [dict valueForKey:'date']];
      [self assert: YES equals: [dict valueForKey:'isMorning']];
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
