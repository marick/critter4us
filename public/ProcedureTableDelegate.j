@import <Foundation/CPObject.j>

@implementation ProcedureTableDelegate : CPObject
{
  CPMutableArray procedures;
}

- (id)init
{
  var request = [CPURLRequest requestWithURL: @"http://localhost:7000/json/procedures"]; 
  var data = [CPURLConnection sendSynchronousRequest: request   
                              returningResponse:nil error:nil]; 
  var str = [data description]; 
  alert(str)
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
  alert([sender clickedRow]);
}

@end
