@import <Critter4Us/page-for-making-reservations/state-machine/GatheringReservationDataStepPMR.j>
@import <Critter4Us/page-for-making-reservations/state-machine/GatheringGroupDataStepPMR.j>
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

- (void) test_start_by_initializing_collaborators
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

- (void) test_when_data_is_available_pass_it_to_persistent_store_and_resign
{
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
      [sut.master shouldReceive: @selector(nextStep:)
                           with: GatheringGroupDataStepPMR];
    }];
}

@end
