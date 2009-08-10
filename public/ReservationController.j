@import <Foundation/CPObject.j>
@import "SecondStageController.j"

@implementation ReservationController : SecondStageController
{
  // outlets
  CPButton button;
}


- (void) makeReservation: (CPButton) sender
{
  var data = {'date':date,'procedures':procedures,'animals':animals}
  var reservationID = [persistentStore makeReservation: data];
  [[CPNotificationCenter defaultCenter] postNotificationName: NewReservationNews
   object: reservationID];
}

@end
