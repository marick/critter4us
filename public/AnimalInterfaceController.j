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
  CPMutableDictionary isChosen;
  CPDictionary exclusions;

  // For testing
  BOOL awakened;
}

- (void)awakeFromCib
{
  if (awakened) return;
  awakened = YES;
  allAnimals = [persistentStore allAnimalNames];

  availableAnimals = [self allAnimalsCopyProperlySorted];
  isChosen = [self allTheseAnimalsAreUnchosen: availableAnimals];

  [self setUpNotifications];
  [containingView setHidden:YES]; 
  [table reloadData];
}

- (CPArray)allAnimalsCopyProperlySorted
{
  var retval = [CPArray arrayWithArray: allAnimals];
  [retval sortUsingSelector: @selector(caseInsensitiveCompare:)];
  return retval;
}

- (CPDictionary)allTheseAnimalsAreUnchosen: aNameArray
{
  var retval = [CPMutableDictionary dictionary];
  for(var i=0; i < [aNameArray count]; i++)
    {
      [retval setValue: NO forKey: aNameArray[i]];
    }
  return retval;
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
  availableAnimals = [self allAnimalsCopyProperlySorted];
  isChosen = [self allTheseAnimalsAreUnchosen: availableAnimals];

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
  var name = availableAnimals[index];
  [isChosen setValue: (![isChosen valueForKey: name]) forKey: name];
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
  name = availableAnimals[rowIndex];
  if (column == nameColumn)
    return name;
  else
    return [isChosen valueForKey: name];
}

@end
