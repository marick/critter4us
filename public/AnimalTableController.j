@import <Foundation/CPObject.j>

@implementation AnimalTableController : CPObject
{
  CPMutableArray animals;
}

- (id)init
{
  var request = [CPURLRequest requestWithURL: @"http://localhost:7000/json/animals"]; 
  var data = [CPURLConnection sendSynchronousRequest: request   
                              returningResponse:nil error:nil]; 
  var str = [data description]; 
  var json = [str objectFromJSON];
  animals = json["animals"];
  return self;
}

- (CPInteger) numberOfRowsInTableView:(CPTableView)aTableView
{
  return [animals count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn: (CPTableColumn)column row:(CPInteger)rowIndex
{
  return [animals objectAtIndex:rowIndex];
}


@end
