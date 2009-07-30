@import <Foundation/CPObject.j>

@implementation ProcedureInterfaceController : CPObject
{
  // outlets
  CPTableView unchosenProcedureTable;
  CPTableView chosenProcedureTable;
  CPView containingView;
  id persistentStore;

  id unchosenProcedures;
}

- (void)awakeFromCib
{
  unchosenProcedures = [persistentStore allProcedureNames];
  [self setUpNotifications];
  [unchosenProcedureTable reloadData];
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
  return [unchosenProcedures count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn: (CPTableColumn)column row:(CPInteger)rowIndex
{
  return [unchosenProcedures objectAtIndex:rowIndex];
}

- (void)chooseProcedure:(id)sender
{
  var row = [unchosenProcedureTable clickedRow];
  var procedure = [unchosenProcedures objectAtIndex: row];
  [unchosenProcedures removeObjectAtIndex: row];

  [[CPNotificationCenter defaultCenter] postNotificationName: @"procedure chosen" object: procedure];
  [unchosenProcedureTable reloadData];
}

@end
