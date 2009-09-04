@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation PMRPageController : AwakeningObject
{
  CPView pageView;
  CPPanel target;
  CPPanel animalDragList;
  CPPanel procedureDragList;
  CPObject groupingsController;

  CPBoolean displayFloatingWindows;
}

-(void) awakeFromCib
{
  displayFloatingWindows = NO;
}

-(void) setDisplayFloatingWindows: (CPBoolean) value
{
  displayFloatingWindows = value;
}

-(void) appear
{
  [pageView setHidden: NO];
  if (displayFloatingWindows)
  {
    [procedureDragList orderFront: self];
    [animalDragList orderFront: self];
    [target orderFront: self];
  }
}

-(void) disappear
{
  [pageView setHidden: YES];
  [procedureDragList orderOut: self];
  [animalDragList orderOut: self];
  [target orderOut: self];
}


@end
