@import <Foundation/CPObject.j>
@import "SecondStageController.j"

@implementation ReservationController : SecondStageController
{
  // outlets
  CPButton button;

  // State ready
  CPArray procedures;
  CPArray animals;
}

- (void)awakeFromCib
{
  if (awakened) return;
  [super awakeFromCib];
  [button setEnabled: NO];
}

- (void) setUpNotifications
{
  [super setUpNotifications]

  [NotificationCenter
   addObserver: self
   selector: @selector(proceduresChosen:)
   name: ProcedureUpdateNews
   object: nil];

  [NotificationCenter
   addObserver: self
   selector: @selector(animalsChosen:)
   name: AnimalUpdateNews
   object: nil];
}


- (void) proceduresChosen: aNotification
{
  procedures = [aNotification object];
  [self updateButton];
}

- (void) animalsChosen: aNotification
{
  animals = [aNotification object];
  [self updateButton];
}

- (void) makeReservation: (CPButton) sender
{
  var data = {'date':date,'procedures':procedures,'animals':animals}
  var reservationID = [persistentStore makeReservation: data];
  [[CPNotificationCenter defaultCenter] postNotificationName: NewReservationNews
   object: reservationID];
}

- (void) updateButton
{
  if (procedures && animals)
    {
      [button setEnabled:YES];
    }
}

@end
