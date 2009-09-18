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
  var group = [self currentGroup];
  if ([group isEmpty]) return;

  var content = [[groupCollectionView content] copy];
  [content addObject: group];
  [groupCollectionView setContent: content];
  [groupCollectionView setNeedsDisplay: YES];
  [newGroupButton setNeedsDisplay:YES];
  [NotificationCenter postNotificationName: NewGroupNews object: nil];
}

- (void) spillIt: (CPMutableDictionary) dict
{
  var allGroups = [[groupCollectionView content] copy];
  var building = [self currentGroup];
  if (! [building isEmpty])
  {
    allGroups = [allGroups arrayByAddingObject: building];
  }
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

-(Group) currentGroup
{
  return [[Group alloc] initWithProcedures: [readOnlyProcedureCollectionView content]
                                   animals: [readOnlyAnimalCollectionView content]];
}


@end



