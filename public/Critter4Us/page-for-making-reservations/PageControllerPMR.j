@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation PageControllerPMR : AwakeningObject
{
  CPView pageView;
  DragListPMR animalDragList;
  DragListPMR procedureDragList;
  CPPanel workupHerdPanel;

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
  alert([[pageView subviews] description]);
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
  [workupHerdPanel orderFront: self];
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
  [workupHerdPanel orderOut: self];
}
@end