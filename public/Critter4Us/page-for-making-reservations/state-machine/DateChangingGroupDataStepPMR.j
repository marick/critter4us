@import "StepPMR.j"
@import "GatheringGroupDataStepPMR.j"

@implementation DateChangingGroupDataStepPMR : GatheringGroupDataStepPMR
{
}

- (void) initializeControllersWithEntirelyNewInfo: aNotification
{
  var dict = [aNotification object];
  [self allButRecalculatingGroups: dict];
  [reservationDataController startDestructivelyEditingDateTime: self];
}



@end
