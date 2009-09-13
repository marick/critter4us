@import "../controller/PanelController.j"

@implementation NamedObjectControllerPMR : PanelController
{
  CPCollectionView available;
  CPCollectionView used;
  CPArray objects;
}

- (void) beginUsing: someObjects
{
  objects = [someObjects sortedArrayUsingSelector: @selector(compareNames:)];
  [available setContent: objects];
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
