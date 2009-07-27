@import <Foundation/CPObject.j>

@implementation AnimalTableController : CPObject
{
  CPTableView table;

  CPMutableArray animals;
  CPDictionary exclusions;
}

- (id)init
{
//  var request = [CPURLRequest requestWithURL: @"http://localhost:7000/json/all_animal_data"]; 
//  var data = [CPURLConnection sendSynchronousRequest: request   
//                              returningResponse:nil error:nil]; 
//  var str = [data description]; 
//  var json = [str objectFromJSON];
//  return [self initWithAnimalArray: json["animals"]];

  [self setUpNotifications]
  return self;
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


// DELETEME
- (void)filterByProcedure:(CPString)aName
{
  var url = [CPString stringWithFormat: @"http://localhost:7000/json/selected_animals?procedure=%s", aName];
  var request = [CPURLRequest requestWithURL: url]; 
  var data = [CPURLConnection sendSynchronousRequest: request   
                              returningResponse:nil error:nil]; 
  var str = [data description]; 
  var json = [str objectFromJSON];
  animals = json["animals"];
  [table reloadData];
}


@end
