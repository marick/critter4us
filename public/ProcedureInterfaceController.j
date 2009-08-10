@import <Foundation/CPObject.j>
@import "Constants.j"

@implementation ProcedureInterfaceController : CPObject
{
  // outlets
  CPTableView unchosenProcedureTable;
  CPTableView chosenProcedureTable;
  CPView containingView;
  id persistentStore;

  id unchosenProcedures;
  id chosenProcedures;

  // Test support
  BOOL awakened;
}

- (void)awakeFromCib
{
  unchosenProcedures = [persistentStore allProcedureNames];
  [unchosenProcedures sortUsingSelector: @selector(caseInsensitiveCompare:)];
  chosenProcedures = [CPArray array];
  [self setUpNotifications];
  [unchosenProcedureTable reloadData];
  [chosenProcedureTable reloadData];
  [containingView setHidden:YES]; 
  awakened = YES;
}

- (void) setUpNotifications
{
  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(becomeAvailable:)
   name: CourseSessionDescribedNews
   object: nil];
}

- (void)stopObserving 
{
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}

- (void) becomeAvailable: aNotification
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



- (void) moveProcedureAtIndex: index from: fromArray to: toArray
{
  var procedure = [fromArray objectAtIndex: index];
  [fromArray removeObjectAtIndex: index];
  [toArray addObject: procedure];
  [toArray sortUsingSelector: @selector(caseInsensitiveCompare:)];
}

- (void) updateEveryoneWhoCaresAboutMovement
{
  [[CPNotificationCenter defaultCenter] 
         postNotificationName: @"procedures chosen"
	 object: chosenProcedures];
  [chosenProcedureTable deselectAll: self];
  [unchosenProcedureTable deselectAll: self];
  [chosenProcedureTable reloadData];
  [unchosenProcedureTable reloadData];
}
@end
