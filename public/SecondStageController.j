@import "AwakeningObject.j"

@implementation SecondStageController : AwakeningObject
{
  CPView containingView;
  id persistentStore;
}

- (void)awakeFromCib
{
  [super awakeFromCib];
  [containingView setHidden: YES];
}

- (void) setUpNotifications
{
  [NotificationCenter
   addObserver: self
   selector: @selector(becomeAvailable:)
   name: CourseSessionDescribedNews
   object: nil];
}

- (void) becomeAvailable: aNotification
{
  [containingView setHidden:NO];
}

@end
