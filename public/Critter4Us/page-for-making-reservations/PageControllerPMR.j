@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation PageControllerPMR : AwakeningObject
{
  CPView pageView;
  CPArray panelControllers;
}

- (void) addPanelController: aController
{
  [[self panelControllers] addObject: aController];
}

- (void) addPanelControllersFromArray: controllers
{
  [[self panelControllers] addObjectsFromArray: controllers];
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

- (CPArray) panelControllers
{
  if (!panelControllers) panelControllers = [];
  return panelControllers;
}

@end
