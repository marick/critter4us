@import "SecondStageController.j"

@implementation ProcedureInterfaceController : SecondStageController
{
  // outlets
  CPTableView unchosenProcedureTable;
  CPTableView chosenProcedureTable;

  id unchosenProcedures;
  id chosenProcedures;
}

// Table methods

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

// Coordinator methods

- (void)beginUsingProcedures: (CPArray) procedures
{
  [self beginUsingChosenProcedures: [] unchosenProcedures: procedures];
}

- (void)beginUsingChosenProcedures: (CPArray) chosen unchosenProcedures: (CPArray) unchosen
{
  unchosenProcedures = [CPArray arrayWithArray: unchosen];
  [unchosenProcedures sortUsingSelector: @selector(caseInsensitiveCompare:)];

  chosenProcedures = chosen;
  [chosenProcedures sortUsingSelector: @selector(caseInsensitiveCompare:)];

  [unchosenProcedureTable reloadData];
  [chosenProcedureTable reloadData];
}

- (void) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: chosenProcedures forKey: 'procedures'];
}

// Responding to clicks 

- (void)chooseProcedure:(id)sender
{
  [self moveProcedureAtIndex: [unchosenProcedureTable clickedRow]
                        from: unchosenProcedures 
                          to: chosenProcedures];
  [self updateEveryoneWhoCaresAboutMovement];
}


- (void)unchooseProcedure: (id) sender
{
  [self moveProcedureAtIndex: [chosenProcedureTable clickedRow]
                        from: chosenProcedures 
                          to: unchosenProcedures];
  [self updateEveryoneWhoCaresAboutMovement];
}



// Util

- (void) moveProcedureAtIndex: index from: fromArray to: toArray
{
  var procedure = [fromArray objectAtIndex: index];
  [fromArray removeObjectAtIndex: index];
  [toArray addObject: procedure];
  [toArray sortUsingSelector: @selector(caseInsensitiveCompare:)];
}

- (void) updateEveryoneWhoCaresAboutMovement
{
  [NotificationCenter postNotificationName: ProcedureUpdateNews
                                    object: chosenProcedures];
  [chosenProcedureTable deselectAll: self];
  [unchosenProcedureTable deselectAll: self];
  [chosenProcedureTable reloadData];
  [unchosenProcedureTable reloadData];
}

@end
