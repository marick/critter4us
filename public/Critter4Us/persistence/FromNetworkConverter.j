@import "../model/NamedObject.j"
@import "../model/Procedure.j"
@import "../model/Animal.j"
@import "../model/Group.j"
@import "../util/Time.j"
@import "../util/CritterObject.j"

@implementation FromNetworkConverter : CritterObject
{
}

+ (CPDictionary) convert: jsHash
{
  return [[[self alloc] init] convert: jsHash];
}

- (CPDictionary) convert: jsHash
{
  var retval = [CPDictionary dictionary];
  if (jsHash['timeSensitiveExclusions'])
  {
    var sensitive = jsHash['timeSensitiveExclusions'];
    var timeless = jsHash['timelessExclusions'];
    jsHash['allExclusions'] = [self combine: sensitive with: timeless];
  }
  for (key in jsHash)
  {
    if (jsHash.hasOwnProperty(key)) 
    {
      switch(key)
      {
      case 'time': 
        if (jsHash['time'] == Morning)
          [retval setValue: [Time morning] forKey: 'time'];
        if (jsHash['time'] == Afternoon)
          [retval setValue: [Time afternoon] forKey: 'time'];
        if (jsHash['time'] == Evening)
          [retval setValue: [Time evening] forKey: 'time'];
        break;
      case 'animal':
        var obj = [self animal: jsHash[key] kindMap: jsHash['kindMap']];
        [retval setValue: obj forKey: key];
        break;
      case 'animals':
        var array = [self animals: jsHash[key] kindMap: jsHash['kindMap']];
        [retval setValue: array forKey: key];
        break;
      case 'unused animals':
        var array = [self unusedAnimals: jsHash[key]];
        [retval setValue: array forKey: key];
        break;
      case 'procedure':
        var procedure = [self procedure: jsHash[key]
                             exclusions: jsHash['allExclusions']
                                kindMap: jsHash['kindMap']];
        [retval setValue: procedure forKey: key];
        break;
      case 'procedures':
        var array = [self procedures: jsHash[key]
                          exclusions: jsHash['allExclusions']
                             kindMap: jsHash['kindMap']];
        [retval setValue: array forKey: key];
        break;
      case 'group':
        var obj = [self group: jsHash[key] kindMap: jsHash['kindMap']];
        [retval setValue: obj forKey: key];
        break;
      case 'groups':
        var obj = [self groups: jsHash[key] kindMap: jsHash['kindMap']];
        [retval setValue: obj forKey: key];
        break;
      default:
        [retval setValue: jsHash[key] forKey: key];
        break;
      }
    }
  }
  return retval;
}

- (Animal) animal: name kindMap: kindMap
{
  return [[Animal alloc] initWithName: name kind: kindMap[name]];
}


- (CPArray) animals: names kindMap: kindMap
{
  var retval = [];
  var enumerator = [names objectEnumerator];
  var name;
  while (name=[enumerator nextObject])
  {
    [retval addObject: [self animal: name kindMap: kindMap]];
  }
  return retval;
}

- (CPArray) unusedAnimals: array
{
  var retval = [];
  for(i=0; i < [array count]; i++)
  {
    [retval addObject: [[NamedObject alloc] initWithName: array[i]]];
  }
  return retval;
}

- (Procedure) procedure: name exclusions: exclusions kindMap: kindMap
{
  if (exclusions)
  {
    var animalArray = [self animals: exclusions[name] kindMap: kindMap];
    return [[Procedure alloc] initWithName: name excluding: animalArray];
  }
  else
  {
    return [[Procedure alloc] initWithName: name];
  }
}

- (CPArray) procedures: names exclusions: exclusions kindMap: kindMap
{
  var retval = [];
  var enumerator = [names objectEnumerator];
  var name;
  while (name=[enumerator nextObject])
  {
    [retval addObject: [self procedure: name exclusions: exclusions kindMap: kindMap]];
  }
  return retval;
}

- (Animal) group: jsHash kindMap: kindMap
{
  var procedures = [self procedures: jsHash['procedures']
                         exclusions: nil
                            kindMap: kindMap];
  var animals = [self animals: jsHash['animals'] kindMap: kindMap];
  return [[Group alloc] initWithProcedures: procedures animals: animals];
}

- (Animal) groups: array kindMap: kindMap
{
  var retval = [];
  var enumerator = [array objectEnumerator];
  var data;
  while (data=[enumerator nextObject])
  {
    [retval addObject: [self group: data kindMap: kindMap]];
  }
  return retval;
}

// 

- (CPArray) combine: one with: another // TODO: move this
{
  retval = {};
  var procedures = [[CPDictionary dictionaryWithJSObject: one] allKeys];
  for (var i=0; i < [procedures count]; i++)
  {
    var procedureName = procedures[i];
    var oneArray = one[procedureName] || [];
    var anotherArray = another[procedureName] || [];
    retval[procedureName] = [oneArray arrayByAddingObjectsFromArray: anotherArray];
  }
  return retval
}

@end
