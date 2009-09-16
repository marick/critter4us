@import "../controller/PanelController.j"
@import "ConstantsPMR.j"

@implementation GroupControllerPMR : PanelController
{
  CPButton newGroupButton;
  CPCollectionView readOnlyProcedureCollectionView;
  CPCollectionView readOnlyAnimalCollectionView;
  CPCollectionView groupCollectionView;
}

- (void) awakeFromCib
{
  [groupCollectionView setContent: []];
}

- (void) prepareToFinishReservation
{
  [newGroupButton setHidden: NO];
}

- (void) newGroup: sender
{
  var group = [[Group alloc] initWithProcedures: [readOnlyProcedureCollectionView content]
                                        animals: [readOnlyAnimalCollectionView content]];
  var content = [[groupCollectionView content] copy];
  [content addObject: group];
  [groupCollectionView setContent: content];
  [groupCollectionView setNeedsDisplay: YES];
}

- (void) restart
{
  CPLog("what does restart mean?");
  [self disappear];
  [newGroupButton setHidden: YES];
}
@end



