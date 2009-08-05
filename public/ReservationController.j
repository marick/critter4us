@import <Foundation/CPObject.j>

@implementation ReservationController : CPObject
{
  // outlets
  CPView containingView;
  id persistentStore;
  CPButton button;

  // State ready

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
  [containingView setHidden:NO];
}

- (void) proceduresChosen: aNotification
{
}

- (void) animalsChosen: aNotification
{
}

- (void) makeReservation: (CPButton) sender
{
  alert('click!');
}



@end
