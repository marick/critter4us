@import <Foundation/CPObject.j>

@implementation ProcedureTableController : CPObject
{
  CPMutableArray procedures;
  id animalTableController;
  CPTableView table;
}

- (id)init
{
  var request = [CPURLRequest requestWithURL: @"http://localhost:7000/json/procedures"]; 
  var data = [CPURLConnection sendSynchronousRequest: request   
                              returningResponse:nil error:nil]; 
  var str = [data description]; 
  var json = [str objectFromJSON];
  procedures = json["procedures"];
  return self;
}

- (CPInteger) numberOfRowsInTableView:(CPTableView)aTableView
{
  return [procedures count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn: (CPTableColumn)column row:(CPInteger)rowIndex
{
  return [procedures objectAtIndex:rowIndex];
}

- (void)chooseProcedure:(id)sender
{
  [animalTableController filterByProcedure: [procedures objectAtIndex: [table clickedRow]]];
}

- (void)setHack:(id)aController
{
  animalTableController = aController;
}

@end
