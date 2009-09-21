@import <Foundation/Foundation.j>

@implementation Group : CPObject
{
  // In  0.7.1, this breaks:
  // CPArray procedures, animals;

  // Fix it by separating the variables:
  CPArray procedures;
  CPArray animals;
  CPArray animalsIncorrectlyPresent;
}

- (Group) initWithProcedures: someProcedures animals: someAnimals
{
  self = [super init];
  procedures = someProcedures;
  animals = someAnimals;
  return self;
}

- (CPArray) procedures
{
  return procedures;
}

- (CPArray) animals
{
  return animals;
}

- (CPArray) animalsIncorrectlyPresent
{
  return animalsIncorrectlyPresent;
}

- (void) setProcedures: newProcedures animals: newAnimals
{
  procedures = newProcedures;
  animals = newAnimals
}

- (CPBoolean) isEmpty
{
  if (0 == [procedures count]) return YES;
  if (0 == [animals count]) return YES;
  return NO;
}

- (CPString) name
{
  return [self procedureNames].join(', ');
}

- (CPArray) procedureNames
{
  return [self nameListFrom: procedures];
}

- (CPArray) animalNames
{
  return [self nameListFrom: animals];
}

- (void) nameListFrom: namedObjects
{
  var retval = [];
  var enumerator = [namedObjects objectEnumerator];
  var element;
  while(element = [enumerator nextObject])
  {
    [retval addObject: [element name]];
  }
  return retval;
}

- (CPBoolean) isEqual: other
{
  if (! [[self animals] isEqual: [other animals]]) return NO;
  if (! [[self procedures] isEqual: [other procedures]]) return NO;
  return YES;
}

- (CPInteger) hash
{
  return [self hashForArray: procedures] ^ [self hashForArray: animals];
}

- (CPString) description
{
  return "<Group with" + [procedures description] + " and " + [animals description];
}

- (CPBoolean) containsExcludedAnimals
{
  var composite = [Procedure compositeFrom: procedures];
  var excludedAnimalSet = [CPSet setWithArray: [composite animalsThisProcedureExcludes]];
  var actualAnimalSet = [CPSet setWithArray: [self animals]];
  [actualAnimalSet intersectSet: excludedAnimalSet];
  animalsIncorrectlyPresent = [actualAnimalSet allObjects];
  return [animalsIncorrectlyPresent count] > 0;
    
}


// util

-(CPInteger) hashForArray: array
{
  // Have seen test runs where array hashes don't yield the same value for equal
  // objects, bizarre as that seems. Obj-J bug?
  hash = 0;
  if ([array count] > 0)
    hash = [[[self procedures] objectAtIndex: 0] hash];
  return hash;
}


@end
