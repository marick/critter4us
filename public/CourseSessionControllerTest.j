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

- (void) testCanFlipViewsToAllowDataEntry
{
  [scenario
   previousAction: function() {
      [sut.buildingView setHidden: YES];
      [sut.finishedView setHidden: NO];
    }
  testAction: function() {
      [sut makeViewsAcceptData];
    }
  andSo: function() {
      [self assertFalse: [sut.buildingView hidden]];
      [self assertTrue: [sut.finishedView hidden]];
    }];
}


- (void)testCanFlipToInformativeButImmutableDisplay
{
  [scenario 
   previousAction: function() {
      [self userBeginsWithSomeValues];
      [sut.buildingView setHidden: NO];
      [sut.finishedView setHidden: YES];
    }
  during: function() {
      [sut displaySelectedSession];
    }
  behold: function() {
      [sut.summaryField shouldReceive: @selector(setStringValue:) 
       with: function(value) {
	  [self assertTrue: value.match("some instructor.*some course.*morning.*some date")
	   message: "Expected '" + value + "' to have informative content."];
	  return YES;
	}];
    }
  andSo: function() {
      [self assertTrue: [sut.buildingView hidden]];
      [self assertFalse: [sut.finishedView hidden]];
    }];
}

- (void)testClickingSessionReadyButtonNotifiesListenersOfEvent
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

-(void) userBeginsWithSomeValues
{
  [sut.courseField setStringValue: "some course"];
  [sut.instructorField setStringValue: "some instructor"];
  [sut.dateField setStringValue: "some date"];
  [sut.morningButton setState:CPOnState];
}


@end
