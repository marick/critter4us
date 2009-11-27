@import "../controller/FromToNamedObjectListController.j"

@implementation FromToNamedObjectListControllerPMR : FromToNamedObjectListController
{
}

- (void) withholdNamedObjects: someNamedObjects
{
  [super withholdNamedObjects: someNamedObjects];
  [used setContent: 
       [self array: [used content] without: someNamedObjects]];
  [available setContent: 
            [self array: [available content] without: [used content]]];

  [used setNeedsDisplay: YES];
}



- (void) beginningOfReservationWorkflow
{
  [self disappear];
  [available setContent: []];
  [used setContent: []];
}


// Delegate method from view (that's the way CPCollections communicate)
- (void) objectsRemoved: (CPArray) removed fromList: (NamedObjectCollectionView) list
{
  [super objectsRemoved: removed fromList: list];
  var dict = [CPMutableDictionary dictionary];
  [dict setValue: [used content] forKey: 'used'];
  [NotificationCenter postNotificationName: DifferentObjectsUsedNews
                                    object: self
                                  userInfo: dict];
}


@end
