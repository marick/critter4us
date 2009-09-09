@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation PageControllerPMR : AwakeningObject
{
  CPView pageView;
  CPArray panelControllers;
}


-(void) appear
{
  [pageView setHidden:NO];
  for(var i=0; i < [panelControllers count]; i++)
  {
    [panelControllers[i] showPanelIfAppropriate];
  }
}

-(void) disappear
{
  [pageView setHidden:YES];
  for(var i=0; i < [panelControllers count]; i++)
  {
    [panelControllers[i] hideAnyVisiblePanels];
  }
}

@end
