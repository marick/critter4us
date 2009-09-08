@import "../util/AwakeningObject.j"

@implementation PanelController : AwakeningObject
{
  CPPanel panel;
}

-(void) hideAnyVisiblePanels
{
  [panel orderOut: nil];
}


@end
