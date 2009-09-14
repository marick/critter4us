@import "NamedObjectControllerPMR.j"

@implementation ProcedureControllerPMR : NamedObjectControllerPMR
{
}

- (void) objectsRemoved: (CPArray) removed fromList: (NamedObjectCollectionView) list
{
  [super objectsRemoved: removed fromList: list];
  [NotificationCenter postNotificationName: ProceduresChosenNews object: [used content]];
}


@end
