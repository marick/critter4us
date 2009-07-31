@import "ProcedureInterfaceController.j"
@import "Mock.j"
@import "Scenario.j"

@implementation ProcedureInterfaceControllerTest : OJTestCase
{
  ProcedureInterfaceController sut;
  Scenario scenario;
}

- (void)setUp
{
  sut = [[ProcedureInterfaceController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardCollaborators: ['unchosenProcedureTable',
					'chosenProcedureTable',
					'containingView']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}

- (void)tearDown
{
  [sut stopObserving];
  [scenario checkExpectations];
}



- (void)testInitialAppearance
{
  [scenario given: function() {
      [self persistentStoreExists];
    }
  whileAwakening: function() {
      [self tablesAreFilledWithData];
      // but
      [self tablesAreMadeHidden];
    }
   ]
}

- (void)testChoosingADate
{
  [scenario given: function() {
      [self persistentStoreExists];
    }
  during: function() {
      [self sendNotification: "date chosen"];
    }
  behold: function() {
      [self tablesAreMadeVisible];
    }
   ];
}

- (void)xtestChoosingAProcedure
{
 [scenario given: function() {
      [self persistentStoreHasProcedures: ["chosen", "unchosen"]];
      [self controllerAwakened];
    }
  during: function() {
      [self clickUnchosen: 0];
    }
  behold: function() {
      
    }
  resultingIn: function() {
    }
   ];
}

- (void) persistentStoreExists
{
  [self persistentStoreHasProcedures: ["don't", "care"]];
}

- (void) persistentStoreHasProcedures: anArray
{
  [sut.persistentStore shouldReceive: @selector(allProcedureNames) andReturn: anArray];
}

- (void) sendNotification: (CPString) aName
{
  [[CPNotificationCenter defaultCenter] postNotificationName: @"date chosen"
                                        object: nil];
}


- (void) tablesAreMadeHidden
{
  [sut.containingView shouldReceive: @selector(setHidden:) with: YES];
}

- (void) tablesAreMadeVisible
{
  [sut.containingView shouldReceive: @selector(setHidden:) with: NO];
}

- (void) tablesAreFilledWithData
{
  [sut.unchosenProcedureTable shouldReceive: @selector(reloadData)];
  [sut.chosenProcedureTable shouldReceive: @selector(reloadData)];
}

@end	
