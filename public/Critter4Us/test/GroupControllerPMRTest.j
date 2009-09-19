@import <Critter4Us/page-for-making-reservations/GroupControllerPMR.j>
@import "ScenarioTestCase.j"
@import <Critter4Us/model/Group.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>

@implementation GroupControllerPMRTest : ScenarioTestCase
{
  Animal betsy;
  Animal jake;
  Procedure floating;
  Procedure radiology;
}

- (void)setUp
{
  sut = [[GroupControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: [
       'readOnlyProcedureCollectionView', 'readOnlyAnimalCollectionView',
        'groupCollectionView', 'newGroupButton']];

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  jake = [[Animal alloc] initWithName: 'jake' kind: 'cow'];
  floating = [[Procedure alloc] initWithName: 'floating'];
  radiology = [[Procedure alloc] initWithName: 'radiology'];
}

- (void) testGroupCollectionStartsEmpty
{
  [scenario 
    whileAwakening: function() {
      [sut.groupCollectionView shouldReceive: @selector(setContent:)
                                        with: []];
    }];
}

- (void) testCanBeToldToPrepareToEditGroups
{
  [scenario
    previousAction: function() {
      [sut.newGroupButton setHidden: YES];
      [sut.groupCollectionView setHidden: YES];
    }
    testAction: function() {
      [sut prepareToEditGroups];
    }
  andSo: function() {
      [self assert: NO equals: [sut.newGroupButton hidden] ];
      [self assert: NO equals: [sut.groupCollectionView hidden] ];
    }
   ];
}

- (void) testPreparingToEditGroupsPlacesEmptyGroupOnGroupList
{
  [scenario
    testAction: function() {
      [sut prepareToEditGroups];
    }
  andSo: function() {
      [self assert: 1 equals: [[sut.groupCollectionView content] count]];
      var group = [sut.groupCollectionView content][0];
      [self assert: [] equals: [group procedures]];
      [self assert: [] equals: [group animals]];
    }
   ];
}

- (void) testCanMirrorNamedObjectListsIntoGroupCollectionView
{
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [sut.readOnlyProcedureCollectionView setContent: [floating]];
      [sut.readOnlyAnimalCollectionView setContent: [jake]];
    }
  testAction: function() {
      [sut updateCurrentGroup];
    }
  andSo: function() {
      [self assert: [floating]
            equals: [[sut currentGroup] procedures]];
      [self assert: [jake]
            equals: [[sut currentGroup] animals]];
    }
   ];
}

- (void) testTheMirroringAlsoUpdatesGroupTitle
{
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [sut.readOnlyProcedureCollectionView setContent: [floating]];
    }
  during: function() {
      [sut updateCurrentGroup];
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(refreshTitleForItemAtIndex:)
                                        with: 0];
    }
   ];
}


-(void) testNewGroupAddsAnEntryToTheGroupCollectionView
{
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [self currentGroupHasProcedures: [radiology] animals: [jake]];
    }
    during: function() {
        [sut newGroup: UnusedArgument];
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(setNeedsDisplay:)
                                        with: YES];
    }
  andSo: function() {
      var groups = [sut.groupCollectionView content];
      [self assert: 2 equals: [groups count]];
      [self assertGroup: groups[0]
          hasProcedures: [radiology] animals: [jake]];
      [self assertGroup: groups[1]
          hasProcedures: [] animals: []];
    }];
}

-(void) testFurtherChangesGoToTheNewGroup
{
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [self currentGroupHasProcedures: [radiology] animals: [jake]];
      [sut newGroup: UnusedArgument];
    }
    testAction: function() {
      [self currentGroupHasProcedures: [floating] animals: [betsy]]
    }
  andSo: function() {
      var groups = [sut.groupCollectionView content];
      [self assert: 2 equals: [groups count]];
      [self assertGroup: groups[0]
          hasProcedures: [radiology] animals: [jake]];
      [self assertGroup: groups[1]
          hasProcedures: [floating] animals: [betsy]];
    }];
}


-(void) testNewGroupEnsuresCurrentGroupIsUpToDate
{
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [self currentGroupHasProcedures: [radiology] animals: [jake]];
      [sut.readOnlyAnimalCollectionView setContent: [jake, betsy]];
      [sut.readOnlyProcedureCollectionView setContent: [radiology, floating]];
    }
    testAction: function() {
        [sut newGroup: UnusedArgument];
    }
  andSo: function() {
      var groups = [sut.groupCollectionView content];
      [self assertGroup: groups[0]
          hasProcedures: [radiology, floating] animals: [jake, betsy]];
    }];
}




-(void) testNewGroupFlingsOutANotification
{
  [scenario
  during: function() {
      [sut newGroup: UnusedArgument]
    }
  behold: function() {
      [self listenersWillReceiveNotification: NewGroupNews];
    }];
}

-(void) testNewGroup_Is_AddedIfCurrentlyBuildingIsEmpty
  // This is specific behavior so that people can create groups 
  // they'll later edit.
{
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [self currentGroupHasProcedures: [radiology] animals: []];
    }
  testAction: function() {
      [sut newGroup: UnusedArgument]
    }
  andSo: function() {
      var groups = [sut.groupCollectionView content];
      [self assert: 2 equals: [groups count]];
    }];
}



-(void) testCanSpillGroups
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [self currentGroupHasProcedures: [radiology] animals: [jake]];
      [sut newGroup: UnusedArgument];
      [self currentGroupHasProcedures: [floating] animals: [betsy]];
    }
    testAction: function() {
      [sut spillIt: dict];
    }
  andSo: function() {
      var groups = [dict valueForKey: 'groups'];
      [self assert: 2 equals: [groups count]];
      [self assertGroup: groups[0]
          hasProcedures: [radiology] animals: [jake]];
      [self assertGroup: groups[1]
          hasProcedures: [floating] animals: [betsy]];
    }];
}

-(void) testSpilledGroupIncludesMostRecentChanges
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [sut.readOnlyProcedureCollectionView setContent: [radiology]];
      [sut.readOnlyAnimalCollectionView setContent: [jake]];
    }
    testAction: function() {
      [sut spillIt: dict];
    }
  andSo: function() {
      var groups = [dict valueForKey: 'groups'];
      [self assert: 1 equals: [groups count]];
      [self assertGroup: groups[0]
          hasProcedures: [radiology] animals: [jake]];
    }];
}

/* 
   Not sure what I want the behavior here to be.

-(void)xxx_testAnEmptyCurrentGroupIsNotIncludedInSpilledData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
    previousAction: function() {
      [self previousGroupWithProcedures: [radiology] animals: [jake]];
      [self currentGroupWithProcedures: [] animals: []];
    }
    testAction: function() {
      [sut spillIt: dict];
    }
  andSo: function() {
      var groups = [dict valueForKey: 'groups'];
      [self assert: 1 equals: [groups count]];
      [self assertGroup: groups[0]
          hasProcedures: [radiology] animals: [jake]];
    }];
}
*/

- (void) testCanBackUpToBeginningOfReservationWorkflow
{
  [scenario
    previousAction: function() {
      [sut appear];
      [self assertTrue: [sut wouldShowPanel]];
      [sut.newGroupButton setHidden: NO];
      [sut.groupCollectionView setHidden: NO];
    }
    during: function() {
      [sut beginningOfReservationWorkflow];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderOut:)];
    }
  andSo: function() {
      [self assertFalse: [sut wouldShowPanel]];
      [self assert: YES equals: [sut.newGroupButton hidden] ];
      [self assert: YES equals: [sut.groupCollectionView hidden] ];
    }];
}


- (void) testBackingUpToTheBeginningForgetsOldGroups
{
  [scenario
    during: function() {
      [sut beginningOfReservationWorkflow];
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(setContent:)
                                        with:[]];
    }];
}


// util

-(void) currentGroupHasProcedures: procedures animals: animals
{
  [sut.readOnlyProcedureCollectionView setContent: procedures];
  [sut.readOnlyAnimalCollectionView setContent: animals];
  [sut updateCurrentGroup];
}


-(void)assertGroup: group hasProcedures: procedures animals: animals
{
  [self assert: procedures equals: [group procedures]];
  [self assert: animals equals: [group animals]];
}


@end
