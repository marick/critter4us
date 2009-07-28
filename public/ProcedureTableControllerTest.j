@import "ProcedureTableController.j"

@implementation PersistentStoreMock : CPObject
{
  CPInteger calls;
}

- (PersistentStoreMock)init
{
  [super init];
  calls = 0;
  return self;
}

- (CPArray) allProcedureNames
{
  // Although Javascript arrays are identical to CPArrays,
  // be explicit about what we want.
  calls += 1;
  return [CPArray arrayWithArray: ['procedure1', 'procedure2']];
}
@end

@implementation ProcedureTableControllerTest : OJTestCase
{
  ProcedureTableController controller;
}

- (void)setUp
{
  controller = [[ProcedureTableController alloc] init];
  controller.persistentStore = [[PersistentStoreMock alloc] init];
  [controller awakeFromCib];
}

- (void)testThatAwakeningFetchesNumberOfProcedures
{
  [self assert: 1
        equals: controller.persistentStore.calls];
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

@end	
