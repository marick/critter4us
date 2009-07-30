@import "AnimalInterfaceController.j"
@import "Mock.j"

@implementation AnimalInterfaceControllerTest : OJTestCase
{
  AnimalInterfaceController controller;
  Mock store;
}

- (void)setUp
{
  controller = [[AnimalInterfaceController alloc] init];
  store = [[Mock alloc] init];
  controller.persistentStore = store 
}

- (void)tearDown
{
  [controller stopObserving];
}

- (void)testAwakeningFromCibCausesAnimalsToBeLoaded
{
  [store shouldReceive: @selector(allAnimalNames)
         andReturn: [CPArray arrayWithArray: ['one', 'two', 'three']]];
  [controller awakeFromCib];
  [self assertTrue: [store wereExpectationsFulfilled]];
  
}

- (void)testThatControllerUnhidesWhenDateChosen
{
  var containingView = [[Mock alloc] init];
  controller.containingView = containingView;
  [controller setUpNotifications];

  [containingView shouldReceive: @selector(setHidden:) with:NO];

  [[CPNotificationCenter defaultCenter] postNotificationName: @"date chosen" object: nil];

  [self assertTrue: [containingView wereExpectationsFulfilled]];
}

- (void)testRowsOfTableEqualsNumberOfAnimals
{
  [self startWithStore: ['one', 'two', 'three']];
  [self assert: 3
        equals: [controller numberOfRowsInTableView: 'table view ignored']];
}

- (void)testObjectValueForTableIsAnimalName
{
  [self startWithStore: ['fred', 'betty']];
  [controller awakeFromCib];

  [self assert: "fred"
        equals: [controller tableView: 'ignored'
	                    objectValueForTableColumn: 'ignored'
			    row: 0]];
}

- (void)testAnimalNamesCanBeFilteredByExcludedAnimals
{
  [self startWithStore: ['fred', 'betty']];
  [self notifyOfExclusions: { 'veniculture': ['fred'],
                              'physical exam': [],
                              'floating':[]}];
  [self notifyOfChosenProcedure: 'veniculture'];
  [self assert: 1
        equals: [controller numberOfRowsInTableView: 'table view ignored']];
  [self assert: 'betty'
        equals: [controller tableView: 'ignored'
	                    objectValueForTableColumn: 'ignored'
			    row: 0]];
}


// Util

- (void) startWithStore: (id)aJSArray
{
  [store shouldReceive: @selector(allAnimalNames)
         andReturn: [CPArray arrayWithArray: aJSArray]];
  [controller awakeFromCib];
}

- (void) notifyOfChosenProcedure: (id)aString
{
  [[CPNotificationCenter defaultCenter] postNotificationName: @"procedure chosen"
                                        object: aString];
}

- (void) notifyOfExclusions: (id)aJSHash
{
  dict = [CPDictionary dictionaryWithJSObject: aJSHash recursively: YES];
  [[CPNotificationCenter defaultCenter] postNotificationName: @"exclusions"
   object: dict];
}


@end	
