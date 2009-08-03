@import "ProcedureInterfaceController.j"
@import "ScenarioTestCase.j"

@implementation ProcedureInterfaceControllerTest : ScenarioTestCase
{
  CPArray procedures;
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


- (void)testInitialAppearance
{
  [scenario
   beforeAwakening: function() {
      [self procedures: ["one", "two"]];
    }
  whileAwakening: function() {
      [self tablesWillLoadData];
      // although
      [self controlsWillBeMadeHidden];
    }
  andTherefore: function() {
      [self unchosenProcedureTableWillContain: ["one", "two"]];
      [self chosenProcedureTableWillContain: []];
    }
   ]
}

- (void)testChoosingADate
{
  [scenario 
   during: function() {
      [self sendNotification: "date chosen"];
    }
  behold: function() {
      [self controlsWillBeMadeVisible];
    }
   ];
}

- (void)testChoosingAProcedure
{
  [scenario given: function() {
      [self procedures: ["chosen", "unchosen"]];
    }
  during: function() {
      [self selectProcedure: "chosen"];
    }
  behold: function() {
      [self listenersWillReceiveNotification: @"procedures chosen"
            containingObject: [@"chosen"]];
      [self tablesWillReloadData];
    }
  andTherefore: function() {
      [self unchosenProcedureTableWillContain: ["unchosen"]];
      [self chosenProcedureTableWillContain: ["chosen"]];
    }
   ];
}


- (void)testPutBackAProcedure
{
  [scenario given: function() {
      [self procedure: "betical"
            hasBeenSelectedFrom: ["alpha", "betical", "order"]];
    }
  during: function() {
      [self putBackProcedure: "betical"];
    }
  behold: function() {
      [self listenersWillReceiveNotification: @"procedures chosen"
            containingObject: []];
      [self tablesWillReloadData];
    }
  andTherefore: function() {
      [self unchosenProcedureTableWillContain: ["alpha", "betical", "order"]];
      [self chosenProcedureTableWillContain: []];
    }
   ];
}







- (void) thereAreSomeProcedures
{
  [self procedures: ["don't", "care"]];
}

- (void) procedures: (CPArray) anArray
{
  procedures = anArray;
  [sut.persistentStore shouldReceive: @selector(allProcedureNames) andReturn: anArray];
}


-(void) procedure: aName hasBeenSelectedFrom: anArray
{
  [self procedures: anArray];
  [sut awakeFromCib];
  [self selectProcedure: aName];
}



- (void) selectProcedure: (CPString) aName
{
  var index = [sut.unchosenProcedures indexOfObject: aName];
  [sut.unchosenProcedureTable shouldReceive: @selector(clickedRow)
                              andReturn: index];
  [sut chooseProcedure: sut.unchosenProcedureTable];
}


- (void) putBackProcedure: (CPString) aName
{
  var index = [sut.chosenProcedures indexOfObject: aName];
  [sut.chosenProcedureTable shouldReceive: @selector(clickedRow)
                            andReturn: index];
  [sut unchooseProcedure: sut.chosenProcedureTable];
}



- (void) tablesWillLoadData  // synonym
{
  [self tablesWillReloadData];
}

- (void) tablesWillReloadData
{
  [sut.unchosenProcedureTable shouldReceive: @selector(reloadData)];
  [sut.chosenProcedureTable shouldReceive: @selector(reloadData)];
}


- (void) unchosenProcedureTableWillContain: (CPArray) someProcedures
{
  [self onlyColumnInTable: sut.unchosenProcedureTable
	named: @"unchosen procedure table"
        willContain: someProcedures];
}

-(void) chosenProcedureTableWillContain: (CPArray) someProcedures
{
  [self onlyColumnInTable: sut.chosenProcedureTable
	named: @"chosen procedure table"
        willContain: someProcedures];
}

@end	
