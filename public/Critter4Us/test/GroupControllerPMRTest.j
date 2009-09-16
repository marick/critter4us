@import <Critter4Us/page-for-making-reservations/GroupControllerPMR.j>
@import "ScenarioTestCase.j"
@import <Critter4Us/model/Group.j>

@implementation GroupControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[GroupControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: [
       'readOnlyProcedureCollectionView', 'readOnlyAnimalCollectionView',
        'groupCollectionView', 'newGroupButton']];
}

- (void) testGroupCollectionStartsEmpty
{
  [scenario 
    whileAwakening: function() {
      [sut.groupCollectionView shouldReceive: @selector(setContent:)
                                        with: []];
    }];
}

- (void) testCanBeToldToPrepareForCompletionOfReservation
{
  [scenario
    previousAction: function() {
      [sut.newGroupButton setHidden: YES];
    }
    testAction: function() {
      [sut prepareToFinishReservation];
    }
  andSo: function() {
      [self assert: NO equals: [sut.newGroupButton hidden] ];
    }
   ];
}



-(void) testNewGroupAddsAnEntryToTheGroupCollectionView
{
  [scenario
    previousAction: function() {
      var previously = [[Group alloc] initWithProcedures: []
                                                 animals: []];
      [sut.groupCollectionView setContent: [previously]];
    }
  during: function() {
      [sut newGroup: UnusedArgument]
    }
  behold: function() {
      [sut.groupCollectionView shouldReceive: @selector(setNeedsDisplay:)
                                        with: YES];
    }
  andSo: function() {
      [self assert: 2
            equals: [[sut.groupCollectionView content] count]];
    }];
}

-(void) testNewGroupAddsAnimalsAndProceduresToNewEntry
{
  var betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var floating = [[Procedure alloc] initWithName: 'floating'];

  [scenario
    previousAction: function() {
      [sut.readOnlyProcedureCollectionView setContent: [floating]];
      [sut.readOnlyAnimalCollectionView setContent: [betsy]];
    }
  testAction: function() {
      [sut newGroup: UnusedArgument]
    }
  andSo: function() {
      var group = [[sut.groupCollectionView content] objectAtIndex: 0];
      [self assert: [betsy]
            equals: [group animals]];
      [self assert: [floating]
            equals: [group procedures]];
    }];
}


- (void) testCanBackUpToBeginningOfReservationWorkflow
{
  [scenario
    previousAction: function() {
      [sut appear];
      [self assertTrue: [sut wouldShowPanel]];
      [sut.newGroupButton setHidden: NO];
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
    }];
}


@end
