@import "ReservationController.j"
@import "ScenarioTestCase.j"
@import "Time.j"


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

- (void)testButtonClickSendsDataToPersistentStore
{
  [scenario
   during: function() {
      [sut makeReservation: 'ignored'];
    }
   behold: function() {
      [sut.courseSessionController shouldReceive: @selector(spillIt:)
       with: function(dict) {
	  [dict setValue: "2009-03-05" forKey: 'date'];
	  [dict setValue: [Time afternoon] forKey: 'time'];
	  [dict setValue: "vm333" forKey: 'course'];
	  [dict setValue: 'fred' forKey: 'instructor']
	  return YES;
	}];
      [sut.procedureController shouldReceive: @selector(spillIt:)
       with: function(dict) {
	  [dict setValue: ['procedure 1', 'procedure 2'] forKey: 'procedures'];
	  return YES;
	}];
      [sut.animalController shouldReceive: @selector(spillIt:)
       with: function(dict) {
	  [dict setValue: ['animal 1', 'animal 2'] forKey: 'animals'];
	  return YES;
       }];

      var dictTester = function (h) {
	[self assert: '2009-03-05' equals: [h valueForKey: 'date'] ];
	[self assert: [Time afternoon] equals: [h valueForKey: 'time' ]];
	[self assert: 'vm333' equals: [h valueForKey: 'course'] ];
	[self assert: 'fred' equals: [h valueForKey: 'instructor'] ];
	[self assert: ["procedure 1", "procedure 2"] equals: [h valueForKey: 'procedures']];
	 [self assert: ["animal 1", "animal 2"] equals: [h valueForKey: 'animals']];
 	return YES;
      }
      [sut.persistentStore shouldReceive: @selector(makeReservation:)
                                    with: dictTester
                                    andReturn: "reservation-identifier"];
      [self listenersWillReceiveNotification: NewReservationNews
                            containingObject: "reservation-identifier"];
    }];
}

@end
