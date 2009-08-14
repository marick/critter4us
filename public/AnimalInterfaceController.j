@import <Foundation/CPObject.j>
@import "SecondStageController.j"

@implementation AnimalInterfaceController : SecondStageController
{
  // outlets
  CPTableView table;
  CPTableColumn nameColumn;
  CPTableColumn checkColumn;

  CPArray allAnimals;
  CPArray availableAnimals;
  CPMutableDictionary isChosen;
  CPDictionary exclusions;
  id nameToKind;
}

- (void)awakeFromCib
{
  if (awakened) return;
  [super awakeFromCib];

  var result = [persistentStore allAnimalInfo];
  allAnimals = result[0];
  nameToKind = result[1];

  [self allAnimalsAreAvailable];
  [self noAnimalsAreChosen]

  [table reloadData];
}


// Coordinator methods

- (void) loadExclusionsForDate: date time: time
{
  exclusions = [persistentStore exclusionsForDate: date time: time];
}

- (void) offerAnimalsForProcedures: (CPArray) procedures
{
  [self allAnimalsAreAvailable];
  [self removeAnimalsExcludedByProcedures: procedures];


  oldIsChosen = [CPMutableDictionary dictionaryWithDictionary: isChosen];
  [self noAnimalsAreChosen];
  [self chooseAnimalsAlreadyChosenIn: oldIsChosen];

  [table reloadData];
}

- (void) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [self chosenAnimals] forKey: 'animals'];
}


// Table methods

- (CPInteger) numberOfRowsInTableView:(CPTableView)aTableView
{
  return [availableAnimals count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn: (CPTableColumn)column row:(CPInteger)rowIndex
{
  name = availableAnimals[rowIndex];
  if (column == nameColumn)
    {
      return name + ' (' + nameToKind[name] + ')';
    }
  else
    {
      return [isChosen valueForKey: name];
    }
}

- (void) tableView: table setObjectValue: value forTableColumn: aColumn row: rowIndex
{
  alert("Will do nothing");
}

- (void)tableView:(CPTableView)aTableView willDisplayCell:(id)aCell forTableColumn:(CPTableColumn)aTableColumn row:(id)rowIndex
{
  // TODO: Not implemented in cappuccino yet.
}




// Util

- (void)allAnimalsAreAvailable
{
  availableAnimals = [CPArray arrayWithArray: allAnimals];
  [availableAnimals sortUsingSelector: @selector(caseInsensitiveCompare:)];
}

- (void)noAnimalsAreChosen
{
  isChosen = [CPMutableDictionary dictionary];
  for(var i=0; i < [availableAnimals count]; i++)
    {
      [isChosen setValue: NO forKey: availableAnimals[i]];
    }
}

- (void) removeAnimalsExcludedByProcedures: procedures
{
  for (var i=0; i<[procedures count]; i++)
    {
      [self removeAnimalsExcludedByProcedure: [procedures objectAtIndex: i]];
    }
}
  
- (void) removeAnimalsExcludedByProcedure: (CPString) procedure
{
  var animalsToRemove = [exclusions objectForKey: procedure];
  
  for(var i=0; i < [animalsToRemove count]; i++) 
    {
      var goner = [animalsToRemove objectAtIndex: i];
      [availableAnimals removeObject: goner];
    }
}

- (void) chooseAnimalsAlreadyChosenIn: oldIsChosen
{
  for (var i=0; i<[availableAnimals count]; i++)
    {
      var name = availableAnimals[i];
      [isChosen setValue: [oldIsChosen valueForKey: name]
                forKey: name]
    }
}

- (void) unchooseAllAnimals
{
  for (var i=0; i<[availableAnimals count]; i++)
    {
      var name = availableAnimals[i];
      if ([isChosen valueForKey: name])
	{
	  [self toggleAnimalAtIndex: i];
	}
    }
  [self updateEveryoneWhoCaresAboutChange];
}

- (void) toggleAnimal: (CPTable) sender
{
  [self toggleAnimalAtIndex: [sender clickedRow]];
  [self updateEveryoneWhoCaresAboutChange];
}

- (void) toggleAnimalAtIndex: index
{
  var name = availableAnimals[index];
  [isChosen setValue: (![isChosen valueForKey: name]) forKey: name];
}

- (void) updateEveryoneWhoCaresAboutChange
{
  [table deselectAll: self];
  [table reloadData];
}

- (CPArray) chosenAnimals
{
  // allKeysForObject not implemented. Sadness.
  var retval = [CPArray array];
  // for .. in produces bizarre results.
  var keys = [isChosen allKeys];
  for (var i=0; i< [keys count]; i++)
    {
      var key = [keys objectAtIndex: i];
      if ([isChosen valueForKey: key])
	{
	  [retval addObject: key];
	}
    }
  [retval sortUsingSelector: @selector(caseInsensitiveCompare:)];
  return retval;
}


@end
