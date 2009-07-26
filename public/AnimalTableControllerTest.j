@import "AnimalTableController.j"

@implementation AnimalTableControllerTest : OJTestCase

- (void)testRowsOfTableEqualsNumberOfAnimals
{
  controller = [[AnimalTableController alloc]
		initWithAnimalArray: [1, 2]];
  [self assert: 2 equals: [controller numberOfRowsInTableView: 'ignored']];
}

- (void)testObjectValueForTableIsAnimalName
{
  animals = [{"name":"fred"}, {"name":"betsy"}];
  controller = [[AnimalTableController alloc]
		initWithAnimalArray: animals];
  [self assert: "fred"
   equals: [controller tableView: 'ignored' objectValueForTableColumn: 'ignored' row: 0]];
}


@end	
