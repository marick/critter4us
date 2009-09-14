@import "../controller/PanelController.j"

@implementation NamedObjectControllerPMR : PanelController
{
  CPCollectionView available;
  CPCollectionView used;
}

- (void) beginUsing: someObjects
{
  [available setContent: someObjects];
  [used setContent: []];
  [available setNeedsDisplay: YES];
  [used setNeedsDisplay: YES];
}

// Delegate methods
- (void) objectsRemoved: (CPArray) removed fromList: (NamedObjectCollectionView) list
{
  var sink = (list == used) ? available : used;
  [sink addContent:removed];
  [sink setNeedsDisplay: YES];
}

@end
