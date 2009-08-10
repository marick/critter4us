@import "ReservationController.j"
@import "ScenarioTestCase.j"


@implementation ReservationControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ReservationController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['button', 'containingView',
					'courseSessionController',
					'procedureController',
					'animalController']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}


-(void) testInitialAppearance
{
  [scenario
   whileAwakening: function() {
      [self controlsWillBeMadeHidden];
    }];
}

- (void)testCourseSessionAvailable
{
  [scenario
   during: function() {
      [self sendNotification: CourseSessionDescribedNews];
    }
  behold: function() {
      [self controlsWillBeMadeVisible];
    }
   ];
}

- (void) setControls: controlArray toValues: valueArray
{
  
}

- (void)testButtonClickSendsDataToPersistentStore
{
  [scenario
   during: function() {
      [sut makeReservation: 'ignored'];
    }
   behold: function() {
      [sut.courseSessionController shouldReceive: @selector(spillIt:)
       with: function(dict) {
	  dict['date'] = "2009-03-05";
	  return YES;
	}];
      [sut.procedureController shouldReceive: @selector(spillIt:)
       with: function(dict) {
	  dict['procedures'] = ['procedure 1', 'procedure 2'];
	  return YES;
	}];
      [sut.animalController shouldReceive: @selector(spillIt:)
       with: function(dict) {
	  dict['animals'] = ['animal 1', 'animal 2'];
	  return YES;
       }];

      var hashTester = function (h) {
	[self assert: '2009-03-05' equals: h['date'] ];
	[self assert: ["procedure 1", "procedure 2"] equals: h['procedures']];
	[self assert: ["animal 1", "animal 2"] equals: h['animals']];
 	return YES;
      }
      [sut.persistentStore shouldReceive: @selector(makeReservation:)
                                    with: hashTester
                                    andReturn: "reservation-identifier"];
      [self listenersWillReceiveNotification: NewReservationNews
                            containingObject: "reservation-identifier"];
    }];
}

@end
