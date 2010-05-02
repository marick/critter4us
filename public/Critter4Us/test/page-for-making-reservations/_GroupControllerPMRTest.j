@import <Critter4Us/page-for-making-reservations/GroupControllerPMR.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/view/ButtonCollectionView.j>

@implementation _GroupControllerPMRTest : ScenarioTestCase
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
    previously: function() {
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

  var aGroup = [[Group alloc] initWithProcedures: [] animals: []];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
    }
  during: function() {
      [sut setCurrentGroupProcedures: [floating] animals: [jake]];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(currentRepresentedObject)
                                   andReturn: aGroup];
      [sut.groupCollectionView shouldReceive: @selector(currentNameHasChanged)];
    }
  andSo: function() {
      [self assert: [floating] equals: [aGroup procedures]];
      [self assert: [jake]     equals: [aGroup animals]];
    }
   ];
}

- (void) testWillBecomeAlarmedIfMirroredGroupContainsExcludedAnimals
  // This looks for data inconsistency bugs.
{
  var excluder = [[Procedure alloc] initWithName: 'excluder' excluding: [jake]];
  var mockPopup = [[Mock alloc] initWithName: 'popup'];
  [scenario
    previously: function() {
      [sut prepareToEditGroups];
    }
  during: function() {
      sut.unconditionalPopup = mockPopup; // TODO: there needs to be some idiom for overriding awakeFromCib-set objects. Or have a popup as a global resource?
      [sut setCurrentGroupProcedures: [excluder] animals: [jake]];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(currentRepresentedObject)
                                   andReturn: empty];
      [mockPopup shouldReceive: @selector(setMessage:)
			  with: function(message) {
	  return message.match(/bug/) && message.match(/jake/)
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
    previously: function() {
      [sut prepareToEditGroups];
    }
  during: function() {
      [sut setCurrentGroupProcedures: [floating] animals: []];
    }
  behold: function() {
      [sut.groupCollectionView shouldyReceive: @selector(currentNameHasChanged)];
    }
   ];
}


-(void) testNewGroupAddsAnEntryToTheGroupCollectionView
{
  [scenario
    previously: function() {
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
    previously: function() {
      [sut prepareToEditGroups];
    }
  during: function() {
      [sut newGroup: UnusedArgument]
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(addNamedObjectToContent:)
                                        with: empty];
    }];
}



-(void) test_can_answer_all_the_groups
{
  var someGroup = [[Group alloc] initWithProcedures: [radiology] animals: [jake]];
  var another = [[Group alloc] initWithProcedures: [floating] animals: [betsy]];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
    }
  during: function() {
      return [sut groups];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(content)
                                   andReturn: [someGroup, another]];
    }
  andSo: function() {
      var groups = scenario.result;
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
    previously: function() {
      [sut.newGroupButton setHidden: NO];
      [sut.groupCollectionView setHidden: NO];
    }
    testAction: function() {
      [sut beginningOfReservationWorkflow];
    }
  andSo: function() {
      [self assert: YES equals: [sut.newGroupButton hidden] ];
      [self assert: YES equals: [sut.groupCollectionView hidden] ];
    }];
}

- (void) testAnnouncesThatRestOfPageShouldSwitchToGroup
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake]];
  [scenario
    previously: function() {
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

- (void) testSettingGroupsExternally
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake]];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
    }
  during: function() {
      [sut allPossibleObjects: [group]];
    }
  behold: function() { 
      [sut.groupCollectionView shouldReceive: @selector(becomeEmpty)];
      [sut.groupCollectionView shouldReceive: @selector(addNamedObjectToContent:)
                                        with: group];
      [sut.groupCollectionView shouldReceive: @selector(currentRepresentedObject)
                                   andReturn: group];
      [self listenersWillReceiveNotification: SwitchToGroupNews
                            containingObject: group];
    }
   ];
}


- (void) testUpdatingGroupsCanRemoveAnimalsFromOneGroup
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake, betsy]];
  var changedFloating = [[Procedure alloc] initWithName: 'floating' excluding: [jake]];
  var changedRadiology = [[Procedure alloc] initWithName: 'radiology' excluding: [betsy]];

  // Easier to use the real thing than the mock.
  sut.groupCollectionView = [[ButtonCollectionView alloc] initWithFrame: CGRectMakeZero()];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
      [sut allPossibleObjects: [group]];
    }
  testAction: function() {
      [sut redisplayInLightOf: [changedFloating, changedRadiology]];
    }
  andSo: function() { 
      var extractedGroup = [sut.groupCollectionView content][0];
      [self assertTrue: changedFloating === [extractedGroup procedures][0]];
      [self assert: [betsy] equals: [extractedGroup animals]];
      [self assert: [jake] equals: [extractedGroup animalsFreshlyExcluded]];
    }
   ];
}

- (void) testUpdatingGroupsCanRemoveAnimalsFromMoreThanOneGroup
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake, betsy]];
  var otherGroup = [[Group alloc] initWithProcedures: [radiology] animals: [jake, betsy]];
  var changedFloating = [[Procedure alloc] initWithName: 'floating' excluding: [jake]];
  var changedRadiology = [[Procedure alloc] initWithName: 'radiology' excluding: [betsy]];

  // Easier to use the real thing than the mock.
  sut.groupCollectionView = [[ButtonCollectionView alloc] initWithFrame: CGRectMakeZero()];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
      [sut allPossibleObjects: [group, otherGroup]];
    }
  testAction: function() {
      [sut redisplayInLightOf: [changedFloating, changedRadiology]];
    }
  andSo: function() { 
      var extractedGroup = [sut.groupCollectionView content][0];
      [self assert: [betsy] equals: [extractedGroup animals]];
      [self assert: [jake] equals: [extractedGroup animalsFreshlyExcluded]];
      var otherExtractedGroup = [sut.groupCollectionView content][1];
      [self assert: [jake] equals: [otherExtractedGroup animals]];
      [self assert: [betsy] equals: [otherExtractedGroup animalsFreshlyExcluded]];
    }
   ];
}

- (void) testUpdatingGroupsTellsOtherControllersToUpdate
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake, betsy]];

  // Easier to use the real thing than the mock.
  sut.groupCollectionView = [[ButtonCollectionView alloc] initWithFrame: CGRectMakeZero()];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
      [sut allPossibleObjects: [group]];
    }
  during: function() {
      [sut redisplayInLightOf: [floating, radiology]];
    }
  behold: function() { 
      [self listenersWillReceiveNotification: SwitchToGroupNews
                            containingObject: group];
    }];
}


- (void) testUpdatingGroupsWithAnimalDeletionsRequiresAdvisory
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake, betsy]];
  var changedFloating = [[Procedure alloc] initWithName: 'floating' excluding: [jake, betsy]];

  // Easier to use the real thing than the mock.
  sut.groupCollectionView = [[ButtonCollectionView alloc] initWithFrame: CGRectMakeZero()];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
      [sut allPossibleObjects: [group]];
    }
  during: function() {
      [sut redisplayInLightOf: [changedFloating, radiology]];
    }
  behold: function() { 
      [self listenersWillReceiveNotification: AdviceAboutAnimalsDroppedNews
                                checkingWith: function(notification) {
          var text = [notification object];
          // Order is important.
          [self assertTrue: text.match(/[Gg]roup 1.*betsy.*jake/)];
          return YES;
        }];
    }
   ];
}

- (void) testUpdatingAnEmptyGroupIsHarmless
  // This happens when a reservation-edit is first created
{
  var group = [[Group alloc] initWithProcedures: [] animals: []];
  var changedFloating = [[Procedure alloc] initWithName: 'floating' excluding: [jake, betsy]];

  // Easier to use the real thing than the mock.
  sut.groupCollectionView = [[ButtonCollectionView alloc] initWithFrame: CGRectMakeZero()];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
      [sut allPossibleObjects: [group]];
    }
  during: function() {
      [sut redisplayInLightOf: [changedFloating, radiology]];
    }
  behold: function() { 
      [self listenersShouldHearNo: AdviceAboutAnimalsDroppedNews];
    }
   ];
}


- (void) testUpdatingGroupsWith_NO_AnimalDeletionsRequires_NO_Advisory
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake]];
  var changedFloating = [[Procedure alloc] initWithName: 'floating' excluding: [betsy]];
  sut.groupCollectionView = [[ButtonCollectionView alloc] initWithFrame: CGRectMakeZero()];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
      [sut allPossibleObjects: [group]];
    }
  during: function() {
      [sut redisplayInLightOf: [changedFloating, radiology]];
    }
  behold: function() {
      [self listenersShouldHearNo: AdviceAboutAnimalsDroppedNews];
    }
   ];
}


- (void) testAdvisoryMentionsMultipleDeletions
{
  var group = [[Group alloc] initWithProcedures: [floating] animals: [jake, betsy]];
  var otherGroup = [[Group alloc] initWithProcedures: [radiology] animals: [jake, betsy]];
  var changedFloating = [[Procedure alloc] initWithName: 'floating' excluding: [jake]];
  var changedRadiology = [[Procedure alloc] initWithName: 'radiology' excluding: [betsy]];

  // Easier to use the real thing than the mock.
  sut.groupCollectionView = [[ButtonCollectionView alloc] initWithFrame: CGRectMakeZero()];

  [scenario
    previously: function() {
      [sut prepareToEditGroups];
      [sut allPossibleObjects: [group, otherGroup]];
    }
  during: function() {
      [sut redisplayInLightOf: [changedFloating, changedRadiology]];
    }
  behold: function() { 
      [self listenersWillReceiveNotification: AdviceAboutAnimalsDroppedNews
                                checkingWith: function(notification) {
          var text = [notification object];
          // Order is important.
          [self assertTrue: text.match(/[Gg]roup 1.*jake/)];
          [self assertTrue: text.match(/[Gg]roup 2.*betsy/)];
          return YES;
        }];
    }
   ];
}


// util

-(void)assertGroup: group hasProcedures: procedures animals: animals
{
  [self assert: procedures equals: [group procedures]];
  [self assert: animals equals: [group animals]];
}


@end
