@import "ProcedureInterfaceController.j"
@import "Mock.j"
@import "Scenario.j"

@implementation ProcedureInterfaceControllerTest : OJTestCase
{
  ProcedureInterfaceController sut;
}

- (void)setUp
{
  sut = [[ProcedureInterfaceController alloc] init];
  [self sutHasUpwardCollaborators: ['unchosenProcedureTable',
				    'chosenProcedureTable',
				    'containingView']];
  [self sutHasDownwardCollaborators: ['persistentStore']];
}

- (void)sutHasUpwardCollaborators: anArray
{
  [self sutHasCollaborators: anArray];
}

- (void)sutHasDownwardCollaborators: anArray
{
  [self sutHasCollaborators: anArray];
}

- (void)sutHasCollaborators: anArray
{
  for(i=0; i<[anArray count]; i++)
    {
      var collaborator = [anArray objectAtIndex: i];
      sut[collaborator] = [[Mock alloc] init];
    }
}



- (void)testInitialAppearance
{
  [[[Scenario alloc] initForTest: self]
   given: function() {
      [self persistentStoreExists];
    }
  whileAwakening: function() {
      [self tablesAreFilledWithData];
      // but
      [self tablesAreMadeHidden];
    }
   ]
}

- (void) persistentStoreExists
{
  [self persistentStoreHasProcedures: ["don't", "care"]];
}

- (void) persistentStoreHasProcedures: anArray
{
  [sut.persistentStore shouldReceive: @selector(allProcedureNames) andReturn: anArray];
}

- (void) tablesAreMadeHidden
{
  [sut.containingView shouldReceive: @selector(setHidden:) with: YES];
}

- (void) tablesAreFilledWithData
{
  [sut.unchosenProcedureTable shouldReceive: @selector(reloadData)];
  [sut.chosenProcedureTable shouldReceive: @selector(reloadData)];
}

- (void)tearDown
{
  [sut stopObserving];
}
@end	
