@import <Foundation/CPObject.j>
@import "SecondStageController.j"

@implementation ReservationController : SecondStageController
{
  // outlets
  CPButton button;
}


- (void) makeReservation: (CPButton) sender
{
  alert("click!")
  [NotificationCenter postNotificationName: ReservationRequestedNews
                                    object: nil];
}

@end
