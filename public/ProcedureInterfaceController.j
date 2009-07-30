@import <Foundation/CPObject.j>

@implementation ProcedureInterfaceController : CPObject
{
  // outlets
  CPTableView table;
  CPView containingView;
  id persistentStore;

  id procedures;
}

- (void)awakeFromCib
{
  procedures = [persistentStore allProcedureNames];
  [self setUpNotifications];
  [table reloadData];
}

- (void) setUpNotifications
{
  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(dateChosen:)
   name: @"date chosen"
   object: nil];
}

- (void)stopObserving 
{
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}

- (void) dateChosen: aNotification
{
  [containingView setHidden:NO];
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
