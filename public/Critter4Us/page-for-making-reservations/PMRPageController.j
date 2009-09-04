@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation PMRPageController : AwakeningObject
{
  CPView pageView;
  CPPanel target;
  CPPanel animalDragList;
  CPPanel procedureDragList;
  CPObject groupingsController;

  CPBoolean displayFloatingWindowsOnPageReveal;
}

-(void) awakeFromCib
{
  displayFloatingWindowsOnPageReveal = NO;
}

-(void) setDisplayFloatingWindowsOnPageReveal: (CPBoolean) value
{
  displayFloatingWindowsOnPageReveal = value;
}

-(void) appear
{
  [pageView setHidden: NO];
  if (displayFloatingWindowsOnPageReveal)
  {
    [self showFloatingWindows];
  }
}

-(void) showFloatingWindows
{
  [procedureDragList orderFront: self];
  [animalDragList orderFront: self];
  [target orderFront: self];
}

-(void) disappear
{
  [pageView setHidden: YES];
  [self hideFloatingWindows];
}

-(void) hideFloatingWindows
{
  [procedureDragList orderOut: self];
  [animalDragList orderOut: self];
  [target orderOut: self];
}


@end
