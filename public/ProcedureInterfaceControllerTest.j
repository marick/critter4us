@import "ProcedureInterfaceController.j"
@import "Mock.j"
@import "Scenario.j"

@implementation ProcedureInterfaceControllerTest : OJTestCase
{
  ProcedureInterfaceController sut;
  Scenario scenario;

  // Temporary storage for tests
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

- (void)tearDown
{
  [sut stopObserving];
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
      [self tablesWillBeMadeHidden];
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
      [self tablesWillBeMadeVisible];
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


- (void) selectProcedure: (CPString) aName
{
  var index = [procedures indexOfObject: aName];
  [sut.unchosenProcedureTable shouldReceive: @selector(clickedRow)
                              andReturn: index];
  [sut chooseProcedure: sut.unchosenProcedureTable];
}


- (void) listenersWillReceiveNotification: (CPString) aNotificationName containingObject: (id) anObject
{
  
  var selector = CPSelectorFromString([aNotificationName stringByReplacingOccurrencesOfString: " " withString: ""]);

  [[CPNotificationCenter defaultCenter]
   addObserver: scenario.randomListener
   selector: selector
   name: aNotificationName
   object: nil];

  [scenario.randomListener shouldReceive: selector
                           with: function(notification) {
                                    return [[notification object] isEqual: anObject]
                                  }];
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

- (void) sendNotification: (CPString) aName
{
  [[CPNotificationCenter defaultCenter] postNotificationName: @"date chosen"
                                        object: nil];
}


- (void) tablesWillBeMadeHidden
{
  [sut.containingView shouldReceive: @selector(setHidden:) with: YES];
}

- (void) tablesWillBeMadeVisible
{
  [sut.containingView shouldReceive: @selector(setHidden:) with: NO];
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


- (void) table: aTable named: aString willContain: someProcedures
{
  [self assertTable: aTable
        contains: someProcedures
   message: [CPString stringWithFormat: @"%s should contain %s", aString, [someProcedures description]]];
}

- (void) unchosenProcedureTableWillContain: (CPArray) someProcedures
{
  [self table: sut.unchosenProcedureTable named: @"unchosen procedure table"
               willContain: someProcedures];
}

-(void) chosenProcedureTableWillContain: (CPArray) someProcedures
{
  [self table: sut.chosenProcedureTable named: @"chosen procedure table"
        willContain: someProcedures];
}

-(void) assertTable: aTable contains: anArray message: aMessage
{
  [self assert: [sut numberOfRowsInTableView: aTable]
        equals: [anArray count]
	message: aMessage];
  for(var i=0; i<[anArray count]; i++)
    {
      [self assert: [anArray objectAtIndex: i]
            equals: [sut tableView: aTable
       		         objectValueForTableColumn: 'ignored'
                 	 row: i]];
    }
}



@end	
