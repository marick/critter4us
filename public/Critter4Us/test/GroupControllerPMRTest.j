@import <Critter4Us/page-for-making-reservations/GroupControllerPMR.j>
@import "ScenarioTestCase.j"
@import <Critter4Us/model/Group.j>

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

-(void) testCanAddFirstGroupToTheGroupsList
{
  [scenario
    previousAction: function() {
      [self currentGroupWithProcedures: [radiology] animals: [jake]];
    }
  during: function() {
      [sut newGroup: UnusedArgument]
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(setNeedsDisplay:)
                                        with: YES];
    }
  andSo: function() {
      var group = [[sut.groupCollectionView content] objectAtIndex: 0];
      [self assertGroup: group
          hasProcedures: [radiology] animals: [jake]];
    }];
}

-(void) testNewGroupAddsAnEntryToTheGroupCollectionView
{
  [scenario
    previousAction: function() {
      [self previousGroupWithProcedures: [floating] animals: [betsy]];
      [self currentGroupWithProcedures: [radiology] animals: [jake]];
    }
  during: function() {
      [sut newGroup: UnusedArgument]
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(setNeedsDisplay:)
                                        with: YES];
    }
  andSo: function() {
      var groups = [sut.groupCollectionView content];
      [self assert: 2 equals: [groups count]];
      [self assertGroup: [groups lastObject]
          hasProcedures: [radiology] animals: [jake]];
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

-(void) testNewGroupIsOnlyAddedIfCurrentlyBuildingIsNonEmpty
{
  [scenario
    previousAction: function() {
      [self currentGroupWithProcedures: [radiology] animals: []];
    }
  testAction: function() {
      [sut newGroup: UnusedArgument]
    }
  andSo: function() {
      var groups = [sut.groupCollectionView content];
      [self assert: 0 equals: [groups count]];
    }];
}



-(void) testCanSpillCurrentlyBuildingGroup
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
    during: function() {
      [sut spillIt: dict];
    }
  behold: function() {
      [sut.readOnlyProcedureCollectionView shouldReceive: @selector(content)
                                               andReturn: [radiology]];
      [sut.readOnlyAnimalCollectionView shouldReceive: @selector(content)
                                            andReturn: [jake]];
    }
  andSo: function() {
      var group = [[dict valueForKey: 'groups'] objectAtIndex: 0];
      [self assertGroup: group hasProcedures: [radiology] animals: [jake]];
    }];
}



-(void) testCanIncludePreviousGroupsInSpilledData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
    previousAction: function() {
      [self previousGroupWithProcedures: [radiology] animals: [jake]];
      [self currentGroupWithProcedures: [floating] animals: [betsy]];
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

-(void)testAnEmptyCurrentGroupIsNotIncludedInSpilledData
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

-(void) currentGroupWithProcedures: procedures animals: animals
{
  [sut.readOnlyProcedureCollectionView setContent: procedures];
  [sut.readOnlyAnimalCollectionView setContent: animals];
}

-(void) previousGroupWithProcedures: procedures animals: animals
{
  [self currentGroupWithProcedures: procedures animals: animals];
  [sut newGroup: UnusedArgument];
  [self assertGroup: [[sut.groupCollectionView content] lastObject]
      hasProcedures: procedures animals: animals];
}

-(void)assertGroup: group hasProcedures: procedures animals: animals
{
  [self assert: procedures equals: [group procedures]];
  [self assert: animals equals: [group animals]];
}


@end
