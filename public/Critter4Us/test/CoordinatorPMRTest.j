@import <Critter4Us/page-for-making-reservations/CoordinatorPMR.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import "ScenarioTestCase.j"


@implementation CoordinatorPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[CoordinatorPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['reservationDataController', 'animalController', 'procedureController', 'workupHerdController', 'pageController']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}

- (void) testSetsUpControlsAppropriatelyWhenReservationsStart
{
  [scenario
    during: function() {
      [self sendNotification: ReservationDataAvailable withObject: nil];
    }
  behold: function() {
      [sut.reservationDataController shouldReceive:@selector(allowNoDataChanges)];
      [sut.reservationDataController shouldReceive:@selector(prepareToFinishReservation)];
      [sut.procedureController shouldReceive:@selector(appear)];
      [sut.animalController shouldReceive:@selector(appear)];
      [sut.workupHerdController shouldReceive:@selector(appear)];
    }];
}

-(void) testHandsControllersValuableDataWhenCourseSessionIsIdentified
{
  var animals = [  [[Animal alloc] initWithName: 'animal1' kind: 'cow'],
                   [[Animal alloc] initWithName: 'animal2' kind: 'horse']];

  var procedures = [ [[Procedure alloc] initWithName: 'procedure1'],
                     [[Procedure alloc] initWithName: 'procedure2']];
  [scenario
   during: function() {
      var dict = [CPDictionary dictionary];
      [dict setValue: '2009-02-02' forKey: 'date'];
      [dict setValue: [Time morning] forKey: 'time'];
          
      [self sendNotification: ReservationDataAvailable withObject: dict];
    }
   behold: function() {
      [sut.persistentStore shouldReceive: @selector(focusOnDate:time:)
                                    with: ['2009-02-02', [Time morning]]];
      [sut.persistentStore shouldReceive: @selector(animals)
                               andReturn: animals];
      [sut.animalController shouldReceive: @selector(beginUsing:)
                                     with: [animals]];
      [sut.persistentStore shouldReceive: @selector(procedures)
                               andReturn: procedures];
      [sut.procedureController shouldReceive: @selector(beginUsing:)
                                     with: [procedures]];
    }];
  
}


@end
