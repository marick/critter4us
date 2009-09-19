@import "../controller/PanelController.j"
@import "../model/Group.j"
@import "ConstantsPMR.j"

/* This controller knows that the view is some kind of
   CPCollectionView for groups, but it should be insulated from any
   knowledge of how that view represents them on the screen.
*/

@implementation GroupControllerPMR : PanelController
{
  CPButton newGroupButton;
  CPCollectionView readOnlyProcedureCollectionView;
  CPCollectionView readOnlyAnimalCollectionView;
  CPCollectionView groupCollectionView;
}


- (void) beginningOfReservationWorkflow
{
  [groupCollectionView becomeEmpty];
  [self disappear];
  [newGroupButton setHidden: YES];
  [groupCollectionView setHidden: YES];
}

- (void) prepareToEditGroups
{
  [newGroupButton setHidden: NO];
  [groupCollectionView setHidden: NO];
  [groupCollectionView addNamedObjectToContent: [self emptyGroup]];
}

- (void) newGroup: sender
{
  [self addEmptyGroupToCollection];
  [groupCollectionView setNeedsDisplay: YES];
  [NotificationCenter postNotificationName: NewGroupNews object: nil];
}

- (void) spillIt: (CPMutableDictionary) dict
{
  var allGroups = [[groupCollectionView content] copy];
  [dict setValue: allGroups forKey: 'groups'];
}

- (void) updateCurrentGroup
{
  [[groupCollectionView currentRepresentedObject]
    setProcedures: [readOnlyProcedureCollectionView content]
          animals: [readOnlyAnimalCollectionView content]];
  [groupCollectionView currentNameHasChanged];
}

// util

-(Group) emptyGroup
{
  return [[Group alloc] initWithProcedures: [] animals: []];
}

- (void) addEmptyGroupToCollection
{
  [groupCollectionView addNamedObjectToContent: [self emptyGroup]];
}

@end

