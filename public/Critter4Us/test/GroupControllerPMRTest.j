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

  Group empty;
  Group notEmpty;
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
  empty = [[Group alloc] initWithProcedures: [] animals: []];
  notEmpty = [[Group alloc] initWithProcedures: [floating] animals: [betsy]];
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
    during: function() {
      [sut prepareToEditGroups];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(addNamedObjectToContent:)
                                        with: empty];
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
  during: function() {
      [sut updateCurrentGroup];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(currentRepresentedObject)
                                   andReturn: empty];
      [sut.groupCollectionView shouldReceive: @selector(currentNameHasChanged)];
    }
  andSo: function() {
      [self assert: [floating]
            equals: [empty procedures]];
      [self assert: [jake]
            equals: [empty animals]];
    }
   ];
}

- (void) testWillBecomeAlarmedIfMirroredGroupContainsExcludedAnimals
  // This looks for data inconsistency bugs.
{
  var excluder = [[Procedure alloc] initWithName: 'excluder' excluding: [jake]];
  var mockPopup = [[Mock alloc] initWithName: 'popup'];
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [sut.readOnlyProcedureCollectionView setContent: [excluder]];
      [sut.readOnlyAnimalCollectionView setContent: [jake]];
    }
  during: function() {
      sut.unconditionalPopup = mockPopup; // TODO: there needs to be some idiom for overriding awakeFromCib-set objects. Or have a popup as a global resource?
      [sut updateCurrentGroup];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(currentRepresentedObject)
                                   andReturn: empty];
      [mockPopup shouldReceive: @selector(setMessage:)
                          with: function(message) {
          return message.match(/bug.*jake/)
        }];
      [mockPopup shouldReceive: @selector(run)]
    }
  andSo: function() {
      [self assertTrue: [mockPopup wereExpectationsFulfilled]];
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
      [sut.groupCollectionView shouldReceive: @selector(currentNameHasChanged)];
    }
   ];
}


-(void) testNewGroupAddsAnEntryToTheGroupCollectionView
{
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
    }
    during: function() {
        [sut newGroup: UnusedArgument];
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(addNamedObjectToContent:)
                                        with: empty];
      [sut.groupCollectionView shouldReceive: @selector(setNeedsDisplay:)
                                        with: YES];
    }];
}

-(void) testNewGroupFlingsOutANotification
{
  [scenario
    during: function() {
      [sut newGroup: UnusedArgument]
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(currentRepresentedObject)
                                   andReturn: empty];
      [self listenersWillReceiveNotification: SwitchToGroupNews
                            containingObject: empty];
    }];
}

-(void) testNewGroup_Is_AddedEvenIfCurrentlyBuildingOneIsUnfinished
  // This is specific behavior so that people can create groups 
  // they'll later edit.
{
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
      [sut.readOnlyProcedureCollectionView setContent: [radiology]];
      [sut.readOnlyAnimalCollectionView setContent: []];
    }
  during: function() {
      [sut newGroup: UnusedArgument]
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(addNamedObjectToContent:)
                                        with: empty];
    }];
}



-(void) testCanSpillGroups
{
  var dict = [CPMutableDictionary dictionary];
  var someGroup = [[Group alloc] initWithProcedures: [radiology] animals: [jake]];
  var another = [[Group alloc] initWithProcedures: [floating] animals: [betsy]];

  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
    }
  during: function() {
      [sut spillIt: dict];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(content)
                                   andReturn: [someGroup, another]];
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

- (void) testAnnouncesThatRestOfPageShouldSwitchToGroup
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake]];
  [scenario
    previousAction: function() {
      [sut prepareToEditGroups];
    }
  during: function() {
      [sut differentGroupChosen: sut.groupCollectionView];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(currentRepresentedObject)
                                   andReturn: group];
      [self listenersWillReceiveNotification: SwitchToGroupNews
                            containingObject: group];
    }
   ];
}


- (void) testBackingUpToTheBeginningForgetsOldGroups
{
  [scenario
    during: function() {
      [sut beginningOfReservationWorkflow];
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(becomeEmpty)];
    }];
}


// util

-(void)assertGroup: group hasProcedures: procedures animals: animals
{
  [self assert: procedures equals: [group procedures]];
  [self assert: animals equals: [group animals]];
}


@end
