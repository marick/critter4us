@import <Foundation/CPObject.j>

@implementation AnimalTableController : CPObject
{
  CPTableView table;

  id animals;
  CPDictionary exclusions;
}

- (void)awakeFromCib
{
  animals = ['animal 1', 'animal 2'];
  [self setUpNotifications];
  [table reloadData];
}

- (void) setUpNotifications
{
  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(animalListAvailable:)
   name: @"animals"
   object: nil];

  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(newExclusions:)
   name: @"exclusions"
   object: nil];

  [[CPNotificationCenter defaultCenter]
   addObserver: self
   selector: @selector(procedureChosen:)
   name: @"procedure chosen"
   object: nil];
}


- (void)stopObserving
{
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}


- animalListAvailable: aNotification
{
  animals = [aNotification object];
}

- newExclusions: aNotification
{
  exclusions = [aNotification object];
}

- procedureChosen: aNotification
{
  var animalsToRemove = [exclusions objectForKey: [aNotification object]];
  
  for(var i = 0; i < [animalsToRemove count]; i++) 
    {
      var goner = [animalsToRemove objectAtIndex: i];
      [animals removeObject: goner];
    }
}


- (CPInteger) numberOfRowsInTableView:(CPTableView)aTableView
{
  return [animals count];
}

- (void)tableView:(CPTableView)aTableView willDisplayCell:(id)aCell forTableColumn:(CPTableColumn)aTableColumn row:(id)rowIndex
{
  // TODO: Not implemented in cappuccino yet.
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn: (CPTableColumn)column row:(CPInteger)rowIndex
{
  return animals[rowIndex]
}

@end
