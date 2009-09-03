@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation PMRPageController : AwakeningObject
{
  CPView pageView;
  CPPanel target;
  CPPanel animalDragList;
  CPPanel procedureDragList;
  CPObject groupingsController;
}


-(void) appear // TODO: move
{
  [pageView setHidden: NO];
  if ([groupingsController isInputDesired])
  {
    [procedureDragList orderFront: self];
    [animalDragList orderFront: self];
    [target orderFront: self];
  }
}

-(void) disappear // TODO: move to window controller
{
  [pageView setHidden: YES];
  [procedureDragList orderOut: self];
  [animalDragList orderOut: self];
  [target orderOut: self];
}


@end
