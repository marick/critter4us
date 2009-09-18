@import "../controller/PanelController.j"
@import "../model/Group.j"
@import "ConstantsPMR.j"

@implementation GroupControllerPMR : PanelController
{
  CPButton newGroupButton;
  CPCollectionView readOnlyProcedureCollectionView;
  CPCollectionView readOnlyAnimalCollectionView;
  CPCollectionView groupCollectionView;
  CPinteger currentGroupIndex;
}

- (void) awakeFromCib
{
  [groupCollectionView setContent: []];
}

- (void) prepareToEditGroups
{
  [newGroupButton setHidden: NO];
  [groupCollectionView setHidden: NO];
  var firstGroup = [self emptyGroup];
  [groupCollectionView setContent: [firstGroup]];
  currentGroupIndex = 0;
}

- (void) newGroup: sender
{
  [self updateCurrentGroup];
  currentGroupIndex ++;
  [self addEmptyGroupToCollection];
  [groupCollectionView setNeedsDisplay: YES];
  [NotificationCenter postNotificationName: NewGroupNews object: nil];
}

- (void) spillIt: (CPMutableDictionary) dict
{
  [self updateCurrentGroup];
  var allGroups = [[groupCollectionView content] copy];
  [dict setValue: allGroups forKey: 'groups'];
}

- (void) beginningOfReservationWorkflow
{
  [groupCollectionView setContent: []];
  [self disappear];
  [newGroupButton setHidden: YES];
  [groupCollectionView setHidden: YES];
}

- (void) updateCurrentGroup
{
  [[self currentGroup] setProcedures: [readOnlyProcedureCollectionView content]
                             animals: [readOnlyAnimalCollectionView content]];
}

// util

- (Group) currentGroup
{
  return [[groupCollectionView content] objectAtIndex: currentGroupIndex];
}

-(Group) xxx_currentGroup
{
  return [[Group alloc] initWithProcedures: [readOnlyProcedureCollectionView content]
                                   animals: [readOnlyAnimalCollectionView content]];
}

-(Group) emptyGroup
{
  return [[Group alloc] initWithProcedures: [] animals: []];
}

- (void) addEmptyGroupToCollection
{
  var group = [self emptyGroup];
  // CPCollectionViews don't consider adding an element to existing
  // content to be a change, so a copy is appropriate.
  var content = [[groupCollectionView content] copy];
  [content addObject: group];
  [groupCollectionView setContent: content];
}

@end



