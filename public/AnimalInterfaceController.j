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
  id nameToKind;
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
  alert("The program's broken: setObjectvalue should never be called");
}

- (void)tableView:(CPTableView)aTableView willDisplayCell:(id)aCell forTableColumn:(CPTableColumn)aTableColumn row:(id)rowIndex
{
  // TODO: Not implemented in cappuccino yet.
}


// Coordinator methods

- (void) beginUsingAnimals: (CPArray) anArray withKindMap: (id) aJSHash
{
  allAnimals = [CPArray arrayWithArray: anArray]
  nameToKind = aJSHash

  [self allAnimalsAreAvailable];
  [self noAnimalsAreChosen]

  [table reloadData];
}


- (void) withholdAnimals: (CPArray) animalsToRemove
{
  [self allAnimalsAreAvailable];
  for(var i=0; i < [animalsToRemove count]; i++) 
    {
      var goner = [animalsToRemove objectAtIndex: i];
      [availableAnimals removeObject: goner];
      [isChosen setValue: NO forKey: goner];
    }
}

- (void) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [self chosenAnimals] forKey: 'animals'];
}

// Responding to clicks

- (void) toggleAnimal: (CPTable) sender
{
  [self toggleAnimalAtIndex: [sender clickedRow]];
  [table deselectAll: self];
  [table reloadData];
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

- (void) toggleAnimalAtIndex: index
{
  var name = availableAnimals[index];
  [isChosen setValue: (![isChosen valueForKey: name]) forKey: name];
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
