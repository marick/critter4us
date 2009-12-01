@import "../controller/FromToNamedObjectListController.j"

@implementation AnimalsControllerPDA : FromToNamedObjectListController
{
  PanelController availablePanelController;
  PanelController usedPanelController;
  CPButton submitButton;
}

- (void) awakeFromCib
{
  if (awakened) return;
  [super awakeFromCib];
  [availablePanelController disappear];
  [usedPanelController disappear];
}

- (void) appear
{
  [availablePanelController appear];
  [usedPanelController appear];
  [submitButton setHidden: NO];
}

- (void) disappear
{
  [availablePanelController disappear];
  [usedPanelController disappear];
  [submitButton setHidden: YES];
}

- (void) removeAnimalsFromService: sender
{
  var animals = [used content];
  [NotificationCenter postNotificationName: AnimalsToRemoveFromServiceNews
                                    object: animals];
}

@end
