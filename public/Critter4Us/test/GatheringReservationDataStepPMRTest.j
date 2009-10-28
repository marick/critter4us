@import <Critter4Us/page-for-making-reservations/state-machine/GatheringReservationDataStepPMR.j>
@import "StateMachineTestCase.j"
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/util/Time.j>


@implementation GatheringReservationDataStepPMRTest : StateMachineTestCase
{
}

- (void) setUp
{
  sut = [GatheringReservationDataStepPMR alloc];
  [super setUp];
}

- (void) testSetsUpControlsAppropriatelyWhenReservationDataIsAvailable
{
  [scenario
    during: function() {
      [sut start];
    }
  behold: function() {
      [sut.reservationDataController shouldReceive: @selector(beginningOfReservationWorkflow)];
      [sut.animalController shouldReceive: @selector(beginningOfReservationWorkflow)];
      [sut.procedureController shouldReceive: @selector(beginningOfReservationWorkflow)];
      [sut.groupController shouldReceive: @selector(beginningOfReservationWorkflow)];
      [self listenersShouldReceiveNotification: AdvisoriesAreIrrelevantNews];
    }];
}

- (void) testPutsDataToPersistentStoreWhenItIsFullyAvailable
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
      [sut.persistentStore shouldReceive: @selector(loadInfoRelevantToDate:time:notificationName:)
                                    with: ['2009-02-02', [Time morning], InitialDataForACourseSessionNews]];
    }];
}


@end
