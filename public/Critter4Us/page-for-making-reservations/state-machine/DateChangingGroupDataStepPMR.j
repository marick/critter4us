@import "GatheringGroupDataStepPMR.j"

@implementation DateChangingGroupDataStepPMR : GatheringGroupDataStepPMR
{
}

- (void) initializeControllersWithEntirelyNewInfo: aNotification
{
  var dict = [aNotification object];
  [self allButRecalculatingGroups: dict];
  [reservationDataController startDestructivelyEditingTimeslice: self];
}



@end
