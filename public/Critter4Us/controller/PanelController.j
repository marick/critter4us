@import "../util/AwakeningObject.j"

@implementation PanelController : AwakeningObject
{
  CPPanel panel;
  CPBoolean visibilityAppropriate;
}

-(id) init
{
  self = [super init];
  visibilityAppropriate = NO;
  return self;
}

-(id) initWithPanel: aPanel
{
  [self init];
  panel = aPanel;
  [NotificationCenter postNotificationName: NewPanelOnPageNews object: self];
  return self;
}

-(void) appear
{
  visibilityAppropriate = YES;
  [panel orderFront: nil];
}

-(void) disappear
{
  visibilityAppropriate = NO;
  [panel orderOut: nil];
}

-(void) hideAnyVisiblePanels
{
  [panel orderOut: nil];
}

-(void) showPanelIfAppropriate
{
  if (visibilityAppropriate) {
    [panel orderFront: nil];
  }
  else {
    [panel orderOut: nil];
  }
}

-(void) wouldShowPanel
{
  return visibilityAppropriate;
}



@end
