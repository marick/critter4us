@import <Foundation/CPObject.j>
@import "AwakeningObject.j"

@implementation ReservationController : AwakeningObject
{
  // outlets
  CPView containingView;
  id persistentStore;
  CPButton button;

  // State ready
  CPArray procedures;
  CPArray animals;
}

- (void)awakeFromCib
{
  if (awakened) return;
  [super awakeFromCib];
  [containingView setHidden: YES];
  [button setEnabled: NO];
}



- (void) setUpNotifications
{
  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(becomeAvailable:)
   name: CourseSessionDescribedNews
   object: nil];

  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(proceduresChosen:)
   name: ProcedureUpdateNews
   object: nil];

  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(animalsChosen:)
   name: AnimalUpdateNews
   object: nil];
}

- (void) becomeAvailable: aNotification
{
  [containingView setHidden:NO];
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
