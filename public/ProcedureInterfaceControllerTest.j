@import "ProcedureInterfaceController.j"
@import "Mock.j"

@implementation ProcedureInterfaceControllerTest : OJTestCase
{
  ProcedureInterfaceController controller;
  Mock store;
}

- (void)setUp
{
  controller = [[ProcedureInterfaceController alloc] init];
  store = [[Mock alloc] init];
  [store shouldReceive: @selector(allProcedureNames)
         andReturn: [CPArray arrayWithArray: ['procedure1', 'procedure2']]];

  controller.persistentStore = store 
  [controller awakeFromCib];
}

- (void)testThatAwakeningFetchesNumberOfProcedures
{
  [self assertTrue: [store wereExpectationsFulfilled]];
}

- (void)testRowsOfTableEqualsNumberOfProcedures
{
  [self assert: 2
        equals: [controller numberOfRowsInTableView: 'table view ignored']];
}

- (void)testObjectValueForTableIsAnimalName
{
  [self assert: "procedure1"
        equals: [controller tableView: 'ignored'
	                    objectValueForTableColumn: 'ignored'
			    row: 0]];
}

- (void)testPickingProcedureCausesNotification
{
  table = [[Mock alloc] init];

  listener = [[Mock alloc] init];
  [[CPNotificationCenter defaultCenter]
   addObserver: listener
   selector: @selector(procedureChosen:)
   name: @"procedure chosen"
   object: nil];

  [table shouldReceive: @selector(clickedRow) andReturn: 0];
  [listener shouldReceive: @selector(procedureChosen:)
                     with: function(notification) {
                              return [notification object] == @"procedure1";
                            }];


  [controller chooseProcedure: table];

  [self assertTrue: [listener wereExpectationsFulfilled]];
}

@end	
