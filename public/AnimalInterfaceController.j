@import <Foundation/CPObject.j>

@implementation AnimalInterfaceController : CPObject
{
  // outlets
  CPTableView table;
  CPTableColumn nameColumn;
  CPTableColumn checkColumn;
  CPView containingView;
  id persistentStore;

  CPArray allAnimals;
  CPArray availableAnimals;
  CPArray isChosen;
  CPDictionary exclusions;

  // For testing
  BOOL awakened;
}

- (void)awakeFromCib
{
  if (awakened) return;
  awakened = YES;
  allAnimals = [persistentStore allAnimalNames];
  [allAnimals sortUsingSelector: @selector(caseInsensitiveCompare:)];
  [self makeAllAnimalsAvailable];
  [self setUpNotifications];
  [containingView setHidden:YES]; 
  [table reloadData];
}

- (void)makeAllAnimalsAvailable
{
  availableAnimals = [CPArray arrayWithArray: allAnimals];
  isChosen = [CPArray array];
  for(var i=0; i < [availableAnimals count]; i++)
    {
      [isChosen addObject: NO];
    }
}


- (void) setUpNotifications
{
  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(newExclusions:)
   name: @"exclusions"
   object: nil];

  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(proceduresChosen:)
   name: @"procedures chosen"
   object: nil];

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

- (void) newExclusions: aNotification
{
  exclusions = [aNotification object];
}

- (void) proceduresChosen: aNotification
{
  var procedures = [aNotification object];
  [self makeAllAnimalsAvailable];
  for (var i=0; i<[procedures count]; i++)
    {
      [self filterByProcedure: [procedures objectAtIndex: i]];
    }
  [table reloadData];
}
  
- (void) filterByProcedure: (CPString) procedure
{
  
  var animalsToRemove = [exclusions objectForKey: procedure];
  
  for(var i=0; i < [animalsToRemove count]; i++) 
    {
      var goner = [animalsToRemove objectAtIndex: i];
      [availableAnimals removeObject: goner];
    }
}


- (void) toggleAnimal: (CPTable) sender
{
  [self toggleAnimalAtIndex: [sender clickedRow]];
}

- (void) toggleAnimalAtIndex: index
{
  isChosen[index] = !isChosen[index];
}

- (CPInteger) numberOfRowsInTableView:(CPTableView)aTableView
{
  return [availableAnimals count];
}

- (void)tableView:(CPTableView)aTableView willDisplayCell:(id)aCell forTableColumn:(CPTableColumn)aTableColumn row:(id)rowIndex
{
  // TODO: Not implemented in cappuccino yet.
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn: (CPTableColumn)column row:(CPInteger)rowIndex
{
  if (column == nameColumn)
    return availableAnimals[rowIndex];
  else
    return isChosen[rowIndex];
}

@end
