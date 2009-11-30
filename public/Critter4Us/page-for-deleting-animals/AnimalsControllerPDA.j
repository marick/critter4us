@import "../controller/FromToNamedObjectListController.j"

@implementation AnimalsControllerPDA : FromToNamedObjectListController
{
  PanelController availablePanelController;
  PanelController usedPanelController;
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
}

@end
