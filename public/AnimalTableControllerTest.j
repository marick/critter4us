@import "AnimalTableController.j"

@implementation AnimalTableControllerTest : OJTestCase
{
  AnimalTableController controller;
}

- (void)setUp
{
  controller = [[AnimalTableController alloc] init];
}

- (void)tearDown
{
  [controller stopObserving];
}

- (void)testRowsOfTableEqualsNumberOfAnimals
{
  [self notifyOfAnimalArray: ['one', 'two', 'three']];
  [self assert: 3
        equals: [controller numberOfRowsInTableView: 'table view ignored']];
}

- (void)testObjectValueForTableIsAnimalName
{
  [self notifyOfAnimalArray: ['fred', 'betty']];

  [self assert: "fred"
        equals: [controller tableView: 'ignored'
	                    objectValueForTableColumn: 'ignored'
			    row: 0]];
}

- (void)testAnimalNamesCanBeFilteredByExcludedAnimals
{
  [self notifyOfAnimalArray: ['fred', 'betty']];
  [self notifyOfExclusions: { 'veniculture': ['fred'] }];
  [self notifyOfChosenProcedure: 'veniculture'];
  [self assert: 1
        equals: [controller numberOfRowsInTableView: 'table view ignored']];
  [self assert: 'betty'
        equals: [controller tableView: 'ignored'
	                    objectValueForTableColumn: 'ignored'
			    row: 0]];
}


// Util


- (void) notifyOfAnimalArray: (id)aJSArray
{
  [[CPNotificationCenter defaultCenter] postNotificationName: @"animals"
                                        object: aJSArray];
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







- (void)mtestControllerAcceptsNewDates
{
  var controller = [[AnimalTableController alloc] initWithAnimalArray: []];
  var date = new Date(2010, 2, 3);

  [self assertFalse: [controller isTableForDate: date]];

  [[CPNotificationCenter defaultCenter] postNotificationName: @"new date"
   object: date];

  [self assertTrue: [controller isTableForDate: date]]
}



- (void)mtestNewProcedureChoiceFiltersOutAnimalsNotYetAvailable
{
  var animals = [
	     {"name":"ready", 
	      "procedures": [
                  {"name":"venipuncture", "available": new Date(2010, 2, 2)}
			     ]},
	     {"name":"not ready", 
	      "procedures": [
                  {"name":"venipuncture", "available": new Date(2010, 2, 3)}
			     ]}
	      
	     ];
  var controller = [[AnimalTableController alloc] initWithAnimalArray: animals];
}

@end	
