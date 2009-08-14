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
   beforeApp: function() {
      [self procedures: ["B", "a", "c"]];
    }
  whileAwakening: function() {
      [self tablesWillLoadData];
      // although
      [self controlsWillBeMadeHidden];
    }
  andSo: function() {
      [self unchosenProcedureTableWillContain: ["a", "B", "c"]];
      [self chosenProcedureTableWillContain: []];
    }
   ]
}

- (void)testChoosingACourseSession
{
  [scenario 
   during: function() {
      [self sendNotification: CourseSessionDescribedNews];
    }
  behold: function() {
      [self controlsWillBeMadeVisible];
    }
   ];
}

- (void)testChoosingAProcedure
{
  [scenario
   beforeApp: function() {
      [self procedures: ["chosen", "unchosen"]];
    }
  during: function() {
      [self selectProcedure: "chosen"];
    }
  behold: function() {
      [self listenersWillReceiveNotification: ProcedureUpdateNews
            containingObject: [@"chosen"]];
      [self tablesWillReloadData];
    }
  andSo: function() {
      [self unchosenProcedureTableWillContain: ["unchosen"]];
      [self chosenProcedureTableWillContain: ["chosen"]];
    }
   ];
}


- (void)testPutBackAProcedure
{
  [scenario
   beforeApp: function() { 
      [self procedures: ["alpha", "Betical", "order"]];
    }
   previousAction: function() {
      [self procedure: "Betical"
            hasBeenSelectedFrom: ["alpha", "Betical", "order"]];
    }
  during: function() {
      [self putBackProcedure: "Betical"];
    }
  behold: function() {
      [self listenersWillReceiveNotification: ProcedureUpdateNews
            containingObject: []];
      [self tablesWillReloadData];
    }
  andSo: function() {
      [self unchosenProcedureTableWillContain: ["alpha", "Betical", "order"]];
      [self chosenProcedureTableWillContain: []];
    }
   ];
}

- (void) testCanUnchooseAllProcedures
{
  [scenario
   beforeApp: function() {
      [self procedures: ["chosen", "unchosen"]];
    }
  previousAction: function() {
      sut.unchosenProcedures = [];
      sut.chosenProcedures = ['unchosen', 'chosen'];
    }
  during: function() {
      [sut unchooseAllProcedures];
    }
  behold: function() {
      [sut.unchosenProcedureTable shouldReceive:@selector(reloadData)];
      [sut.chosenProcedureTable shouldReceive:@selector(reloadData)];
      [self listenersWillReceiveNotification: ProcedureUpdateNews
            containingObject: []];
    }
  andSo: function() {
      [self unchosenProcedureTableWillContain: ["chosen", "unchosen"]];
      [self chosenProcedureTableWillContain: []];
    }
   ];
  
}



- (void)testSPillingProcedures
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
   given: function() {
      [self procedure: "Betical"
            hasBeenSelectedFrom: ["alpha", "Betical", "order"]];
    }
  sequence: function() {
      [sut spillIt: dict];
    }
  means: function() {
      [self assert: ['Betical'] equals: [dict valueForKey: 'procedures']]
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
