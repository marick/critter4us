@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation PageControllerPMR : CritterObject
{
  CPView pageView;
  CPArray panelControllers;
}

- (void) init
{
  self = [super init];
  [self notificationNamed: NewPanelOnPageNews
                    calls: @selector(addPanelControllerFromNotification:)];
  [self notificationNamed: ClosedPanelOnPageNews
                    calls: @selector(removePanelControllerFromNotification:)];
  return self;
}

- (void) addPanelController: aController
{
  [[self panelControllers] addObject: aController];
}

- (void) addPanelControllersFromArray: controllers
{
  [[self panelControllers] addObjectsFromArray: controllers];
}

- (void) addPanelControllerFromNotification: aNotification
{
  [[self panelControllers] addObject: [aNotification object]];
}

- (void) removePanelControllerFromNotification: aNotification
{
  [[self panelControllers] removeObject: [aNotification object]];
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
