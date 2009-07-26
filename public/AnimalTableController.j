@import <Foundation/CPObject.j>

@implementation AnimalTableController : CPObject
{
  CPTableView table;

  CPMutableArray animals;
}

- (id)init
{
//  var request = [CPURLRequest requestWithURL: @"http://localhost:7000/json/all_animal_data"]; 
//  var data = [CPURLConnection sendSynchronousRequest: request   
//                              returningResponse:nil error:nil]; 
//  var str = [data description]; 
//  var json = [str objectFromJSON];
//  return [self initWithAnimalArray: json["animals"]];

  animals = [ "betsy", "ruth"];
  return self;
}

- (id)initWithAnimalArray: someAnimals
{
  animals = someAnimals
  return self;
}

- (CPInteger) numberOfRowsInTableView:(CPTableView)aTableView
{
  return [animals count];
}

- (void)tableView:(CPTableView)aTableView willDisplayCell:(id)aCell forTableColumn:(CPTableColumn)aTableColumn row:(id)rowIndex
{
  // TODO: Not implemented in cappuccino yet.
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn: (CPTableColumn)column row:(CPInteger)rowIndex
{
  return animals[rowIndex].name
}

- (void)filterByProcedure:(CPString)aName
{
  var url = [CPString stringWithFormat: @"http://localhost:7000/json/selected_animals?procedure=%s", aName];
  var request = [CPURLRequest requestWithURL: url]; 
  var data = [CPURLConnection sendSynchronousRequest: request   
                              returningResponse:nil error:nil]; 
  var str = [data description]; 
  var json = [str objectFromJSON];
  animals = json["animals"];
  [table reloadData];
}


@end
