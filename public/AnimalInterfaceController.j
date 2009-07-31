@import <Foundation/CPObject.j>

@implementation AnimalInterfaceController : CPObject
{
  // outlets
  CPTableView table;
  CPView containingView;
  id persistentStore;

  CPArray allAnimals;
  CPArray availableAnimals;
  CPDictionary exclusions;
}

- (void)awakeFromCib
{
  allAnimals = [persistentStore allAnimalNames];
  [self makeAllAnimalsAvailable];
  [self setUpNotifications];
  [table reloadData];
}

- (void)makeAllAnimalsAvailable
{
  availableAnimals = [CPArray arrayWithArray: allAnimals];
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

- newExclusions: aNotification
{
  exclusions = [aNotification object];
}

- proceduresChosen: aNotification
{
  var procedures = [aNotification object];
  [self makeAllAnimalsAvailable];
  for (var i=0; i<[procedures count]; i++)
    {
      [self filterByProcedure: [procedures objectAtIndex: i]];
    }
  [table reloadData];
}
  
- filterByProcedure: (CPString) procedure
{
  
  var animalsToRemove = [exclusions objectForKey: procedure];
  
  for(var i=0; i < [animalsToRemove count]; i++) 
    {
      var goner = [animalsToRemove objectAtIndex: i];
      [availableAnimals removeObject: goner];
    }
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
  return availableAnimals[rowIndex]
}

@end
