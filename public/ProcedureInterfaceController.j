@import <Foundation/CPObject.j>

@implementation ProcedureInterfaceController : CPObject
{
  // outlets
  CPTableView unchosenProcedureTable;
  CPTableView chosenProcedureTable;
  CPView containingView;
  id persistentStore;

  id unchosenProcedures;
  id chosenProcedures;
}

- (void)awakeFromCib
{
  unchosenProcedures = [persistentStore allProcedureNames];
  chosenProcedures = [CPArray array];
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
  //  CPLog(aTableView);
  //CPLog(unchosenProcedureTable);
  //CPLog(chosenProcedureTable);
  if (aTableView == unchosenProcedureTable)
    return [unchosenProcedures count];
  else
    return [chosenProcedures count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn: (CPTableColumn)column row:(CPInteger)rowIndex
{
  if (aTableView == unchosenProcedureTable)
    return [unchosenProcedures objectAtIndex:rowIndex];
  else
    return [chosenProcedures objectAtIndex:rowIndex];
}

- (void)chooseProcedure:(id)sender
{
  var row = [unchosenProcedureTable clickedRow];
  var procedure = [unchosenProcedures objectAtIndex: row];
  [unchosenProcedures removeObjectAtIndex: row];
  [chosenProcedures addObject: procedure];

  [[CPNotificationCenter defaultCenter] postNotificationName: @"procedure chosen" object: procedure];
  [unchosenProcedureTable deselectAll: self];
  [unchosenProcedureTable reloadData];
  [chosenProcedureTable reloadData];
}

@end
