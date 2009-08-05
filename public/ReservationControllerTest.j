@import "ReservationController.j"
@import "ScenarioTestCase.j"

@implementation ReservationControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ReservationController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['button', 'containingView']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}


-(void) testInitialAppearance
{
  [scenario
   whileAwakening: function() {
      [self controlsWillBeMadeHidden];
      [self thisControlWillBeDisabled: sut.button];
    }];
}

- (void)testChoosingADate
{
  [scenario
   during: function() {
      [self notifyOfSomeDate];
    }
  behold: function() {
      [self controlsWillBeMadeVisible];
    }
   ];
}

- (void)testChoosingADateAndAnimalDoesNotEnableButton
{
  [scenario
   given: function() {
      [sut awakeFromCib];
      [self notifyOfSomeDate];
    }
   after: function() {
      [self notifyOfSomeAnimals];
    }
   behold: function() {
      [self thisControlWillRemainDisabled: sut.button];
    }
   ];
}

- (void)testChoosingADateAndProcedureDoesNotEnableButton
{
  [scenario
   given: function() {
      [sut awakeFromCib];
      [self notifyOfSomeDate];
    }
   after: function() {
      [self notifyOfSomeProcedures];
    }
   behold: function() {
      [self thisControlWillRemainDisabled: sut.button];
    }
   ];
}

- (void)testChoosingAllThreeDataEnablesButton
{
  [scenario
   given: function() {
      [sut awakeFromCib];
      [self notifyOfSomeDate];
      [self notifyOfSomeProcedures];
    }
   during: function() {
      [self notifyOfSomeAnimals];
    }
   behold: function() {
      [self thisControlWillBeEnabled: sut.button];
    }
   ];
}


- (void)testButtonClickSendsDataToPersistentStore
{
  [scenario
   given: function() {
      [sut awakeFromCib];
      [self notifyOfChosenDate: '2009-03-05'];
      [self notifyOfChosenProcedures: ["procedure 1", "procedure 2"]];
      [self notifyOfChosenAnimals: ["animal 1", "animal 2"]];
    }
   during: function() {
      [sut makeReservation: 'ignored'];
    }
   behold: function() {
      [sut.persistentStore shouldReceive: @selector(storeDate:procedures:animals:)
       with: ['2009-03-05', ["procedure 1", "procedure 2"], ["animal 1", "animal 2"]]]
    }
   ];
}


- (void) thisControlWillBeDisabled: (CPControl) aControl
{
  [aControl shouldReceive: @selector(setEnabled:) with: NO];
}

- (void) thisControlWillBeEnabled: (CPControl) aControl
{
  [aControl shouldReceive: @selector(setEnabled:) with: YES];
}

- (void) thisControlWillRemainDisabled: (CPControl) aControl
{
  aControl.failOnUnexpectedSelector = YES;
}
						    


 
@end
