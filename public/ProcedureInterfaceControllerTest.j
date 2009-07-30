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

  controller.persistentStore = store;
}

- (void)tearDown
{
  [controller stopObserving];
}

- (void)testThatControllerUnhidesWhenDateChosen
{
  var containingView = [[Mock alloc] init];
  controller.containingView = containingView;
  [controller awakeFromCib];

  [containingView shouldReceive: @selector(setHidden:) with:NO];

  [[CPNotificationCenter defaultCenter] postNotificationName: @"date chosen" object: nil];

  [self assertTrue: [containingView wereExpectationsFulfilled]];
}

- (void)testThatAwakeningFetchesNumberOfProcedures
{
  [controller awakeFromCib];
  [self assertTrue: [store wereExpectationsFulfilled]];
}

- (void)testRowsOfUnchosenTableInitiallyEqualsNumberOfProcedures
{
  [controller awakeFromCib];
  controller.unchosenProcedureTable = [[Mock alloc] init];

  [self assert: 2
        equals: [controller numberOfRowsInTableView: controller.unchosenProcedureTable]];
}

- (void)testChosenTableInitiallyEmpty
{
  [controller awakeFromCib];
  controller.chosenProcedureTable = [[Mock alloc] init];
  [self assert: 0
        equals: [controller numberOfRowsInTableView: controller.chosenProcedureTable]];
}

- (void)testObjectValueForTableIsProcedureName
{
  [controller awakeFromCib];
  [self assert: "procedure1"
        equals: [controller tableView: controller.unchosenProcedureTable
	                    objectValueForTableColumn: 'ignored'
			    row: 0]];
}



- (void)testPickingProcedureCausesNotification
{
  [controller awakeFromCib];
  unchosenTable = [[Mock alloc] init];
  controller.unchosenProcedureTable = unchosenTable;

  listener = [[Mock alloc] init];
  [[CPNotificationCenter defaultCenter]
   addObserver: listener
   selector: @selector(procedureChosen:)
   name: @"procedure chosen"
   object: nil];

  [unchosenTable shouldReceive: @selector(clickedRow) andReturn: 0];
  [listener shouldReceive: @selector(procedureChosen:)
                     with: function(notification) {
                              return [notification object] == @"procedure1";
                            }];
  [unchosenTable shouldReceive: @selector(reloadData)];


  [controller chooseProcedure: unchosenTable];

  [self assertTrue: [listener wereExpectationsFulfilled]];
  [self assertTrue: [unchosenTable wereExpectationsFulfilled]];
}

- (void)testPickingUnchosenProcedureRemovesEntryFromUnchosenTable
{
  [controller awakeFromCib];
  unchosenTable = [[Mock alloc] init];
  controller.unchosenProcedureTable = unchosenTable;

  [unchosenTable shouldReceive: @selector(clickedRow) andReturn: 0];
  [unchosenTable shouldReceive: @selector(reloadData)];

  [controller chooseProcedure: unchosenTable];
  [self assert: 1
        equals: [controller numberOfRowsInTableView: unchosenTable]];
  [self assert: "procedure2"
        equals: [controller tableView: unchosenTable
	                    objectValueForTableColumn: 'ignored'
			    row: 0]];

  [self assertTrue: [unchosenTable wereExpectationsFulfilled]];
}

-(void)testPickingUnchosenProcedureAddsEntryToChosenTable
{
  [controller awakeFromCib];
  unchosenTable = [[Mock alloc] init];
  controller.unchosenProcedureTable = unchosenTable;
  chosenTable = [[Mock alloc] init];
  controller.chosenProcedureTable = chosenTable;

  [unchosenTable shouldReceive: @selector(clickedRow) andReturn: 0];
  [unchosenTable shouldReceive: @selector(reloadData)];

  [chosenTable shouldReceive: @selector(reloadData)];

  [controller chooseProcedure: unchosenTable];
  [self assert: 1
        equals: [controller numberOfRowsInTableView: chosenTable]];
  [self assert: "procedure1"
        equals: [controller tableView: chosenTable
	                    objectValueForTableColumn: 'ignored'
			    row: 0]];

  [self assertTrue: [chosenTable wereExpectationsFulfilled]];
}

@end	
