@import <Foundation/CPObject.j>

@implementation ProcedureTableController : CPObject
{
  id persistentStore;
  id procedures;
  CPTableView table;
}

- (void)awakeFromCib
{
  procedures = [persistentStore allProcedureNames]
  [table reloadData];
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
  var row = [sender clickedRow];
  var procedure = [procedures objectAtIndex: row];
  [[CPNotificationCenter defaultCenter] postNotificationName: @"procedure chosen" object: procedure];
}

@end
