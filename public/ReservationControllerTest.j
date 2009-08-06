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

// This is a pretty dumb test.
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
      var hashTester = function (h) {
	[self assert: h['date'] equals: '2009-03-05'];
	[self assert: h['procedures'] equals: ["procedure 1", "procedure 2"]];
	[self assert: h['animals'] equals: ["animal 1", "animal 2"]];
 	return YES
      }
      [sut.persistentStore shouldReceive: @selector(makeReservation:)
                                    with: hashTester]
    }];
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
