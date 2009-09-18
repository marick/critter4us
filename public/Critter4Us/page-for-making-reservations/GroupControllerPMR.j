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

- (void) prepareToEditGroups
{
  [newGroupButton setHidden: NO];
  [groupCollectionView setHidden: NO];
}

- (void) newGroup: sender
{
  var group = [self finishEdit];
  var content = [[groupCollectionView content] copy];
  [content addObject: group];
  [groupCollectionView setContent: content];
  [groupCollectionView setNeedsDisplay: YES];
  [newGroupButton setNeedsDisplay:YES];
  [NotificationCenter postNotificationName: NewGroupNews object: nil];
}

- (void) spillIt: (CPMutableDictionary) dict
{
  var building = [self finishEdit];
  var allGroups = [[groupCollectionView content] arrayByAddingObject: building];
  [dict setValue: allGroups forKey: 'groups'];
}

- (void) beginningOfReservationWorkflow
{
  [groupCollectionView setContent: []];
  [self disappear];
  [newGroupButton setHidden: YES];
  [groupCollectionView setHidden: YES];
}

// util

-(Group) finishEdit
{
  return [[Group alloc] initWithProcedures: [readOnlyProcedureCollectionView content]
                                   animals: [readOnlyAnimalCollectionView content]];
}


@end



