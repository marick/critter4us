@import <Foundation/CPObject.j>
@import "SecondStageController.j"

@implementation ReservationController : SecondStageController
{
  // outlets
  CPButton button;

  CPObject courseSessionController;
  CPObject procedureController;
  CPObject animalController;
}


- (void) makeReservation: (CPButton) sender
{
  var dict = [CPMutableDictionary dictionary];
  [courseSessionController spillIt: dict];
  [procedureController spillIt: dict];
  [animalController spillIt: dict];

  var reservationID = [persistentStore makeReservation: dict];
  [[CPNotificationCenter defaultCenter] postNotificationName: NewReservationNews
   object: reservationID];
}

@end
