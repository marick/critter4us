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
  [chosenProcedureTable reloadData];
  [containingView setHidden:YES]; 
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

  [[CPNotificationCenter defaultCenter] postNotificationName: @"procedures chosen" object: chosenProcedures];
  [unchosenProcedureTable deselectAll: self];
  [unchosenProcedureTable reloadData];
  [chosenProcedureTable reloadData];
}

- (void)unchooseProcedure:(id)sender
{
  var row = [chosenProcedureTable clickedRow];
  var procedure = [chosenProcedures objectAtIndex: row];
  [chosenProcedures removeObjectAtIndex: row];
  [unchosenProcedures addObject: procedure];

  [[CPNotificationCenter defaultCenter] postNotificationName: @"procedures chosen" object: chosenProcedures];
  [chosenProcedureTable deselectAll: self];
  [chosenProcedureTable reloadData];
  [unchosenProcedureTable reloadData];
}


@end
