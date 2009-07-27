@import <Foundation/CPObject.j>

@implementation ProcedureTableController : CPObject
{
  id procedures;
  CPTableView table;
}

- (void)awakeFromCib
{
  // TEMP
  procedures = ['procedure 1', 'procedure 2'];
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
  alert("Procedure chosen");
}

@end
