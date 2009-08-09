@import <Foundation/CPObject.j>
@import "Constants.j"

@implementation ReservationController : CPObject
{
  // outlets
  CPView containingView;
  id persistentStore;
  CPButton button;

  // State ready
  CPString date;
  CPArray procedures;
  CPArray animals;

  // For testing
  BOOL awakened;
}

- (void)awakeFromCib
{
  if (awakened) return;
  awakened = YES;
  [self setUpNotifications];
  [containingView setHidden: YES];
  [button setEnabled: NO];
}



- (void) setUpNotifications
{
  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(proceduresChosen:)
   name: @"procedures chosen"
   object: nil];

  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(animalsChosen:)
   name: @"animals chosen"
   object: nil];

  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(dateChosen:)
   name: @"date chosen"
   object: nil];
}


- (void)stopObserving
{
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}

- (void) dateChosen: aNotification
{
  date = [aNotification object];
  [containingView setHidden:NO];
  [self updateButton];
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
  if (date && procedures && animals)
    {
      [button setEnabled:YES];
    }
}

@end
