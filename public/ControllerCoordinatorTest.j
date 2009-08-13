@import "ControllerCoordinator.j"
@import "ScenarioTestCase.j"
@import "Time.j"

@implementation ControllerCoordinatorTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ControllerCoordinator alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['resultController', 'reservationController', 'animalController', 'procedureController', 'courseSessionController']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}

-(void) testInitialBehavior
{
  [scenario
   whileAwakening: function() {
      [sut.courseSessionController shouldReceive: @selector(makeViewsAcceptData)];
      [sut.animalController shouldReceive: @selector(hideViews)];
      [sut.procedureController shouldReceive: @selector(hideViews)];
      [sut.reservationController shouldReceive: @selector(hideViews)];
      [sut.resultController shouldReceive: @selector(hideViews)];
    }];
}


-(void) testChangesDisplayWhenCourseSessionIsIdentified
{
  [scenario
   during: function() {
      [self sendNotification: CourseSessionDescribedNews];
    }
   behold: function() {
      [sut.courseSessionController shouldReceive: @selector(displaySelectedSession)];
      [sut.animalController shouldReceive: @selector(showViews)];
      [sut.procedureController shouldReceive: @selector(showViews)];
      [sut.reservationController shouldReceive: @selector(showViews)];
      [sut.resultController shouldReceive: @selector(hideViews)];
    }];
}

-(void) testInstructsControllersToMakeSureNoDataLeftFromLastSession
{
  [scenario
   during: function() {
      [self sendNotification: CourseSessionDescribedNews];
    }
   behold: function() {
      // 
      [sut.procedureController shouldReceive: @selector(unchooseAllProcedures)];
      [sut.animalController shouldReceive: @selector(unchooseAllAnimals)];
    }
   ];
}


-(void) testInstructsAnimalControllerToLoadExclusionsWhenSessionChosen
{
  [scenario
   during: function() {
      [self sendNotification: CourseSessionDescribedNews];
    }
   behold: function() {
      [sut.courseSessionController shouldReceive: @selector(spillIt:)];
      [sut.animalController shouldReceive: @selector(loadExclusionsForDate:time:)]
    }];
}

- (void) testMakesAnimalControllerWhenProceduresChosenAreUpdated
{
  [scenario
   during: function() {
      [self sendNotification: ProcedureUpdateNews
       withObject: ["a", "b"]];
    }
   behold: function() {
      [sut.animalController shouldReceive: @selector(offerAnimalsForProcedures:)
       with: [["a", "b"]]]
    }];
}


-(void) testCollectsReservationDataAndSendsToPersistentStore
{
  [scenario
   during: function() {
      [self sendNotification: ReservationRequestedNews];
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
    }];
}

-(void) testTellsResultControllerToOfferLinkToNewReservation
{
  [scenario
   during: function() {
      [self sendNotification: ReservationRequestedNews];
    }
   behold: function() {
      // ...
      [sut.persistentStore shouldReceive: @selector(makeReservation:)
                               andReturn: "reservation-identifier"];
      [sut.resultController shouldReceive: @selector(offerReservationView:)
       with: "reservation-identifier"];
      [sut.resultController shouldReceive: @selector(showViews)];
    }];
}

-(void) testInstructsControllersToPrepareForNewCourseSession
{
  [scenario
   during: function() {
      [self sendNotification: ReservationRequestedNews];
    }
   behold: function() {
      // 
      [sut.courseSessionController shouldReceive: @selector(makeViewsAcceptData)];
      [sut.animalController shouldReceive: @selector(hideViews)];
      [sut.procedureController shouldReceive: @selector(hideViews)];
      [sut.reservationController shouldReceive: @selector(hideViews)];

    }];
}

@end
