@import <Foundation/Foundation.j>

@implementation Group : CPObject
{
  // In  0.7.1, this breaks:
  // CPArray procedures, animals;

  // Fix it by separating the variables:
  CPArray procedures;
  CPArray animals;
  CPArray animalsIncorrectlyPresent;  // Used in final error checking

  CPArray animalsFreshlyExcluded;  // Used as group contents update
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

- (CPArray) animalsFreshlyExcluded
{
  return animalsFreshlyExcluded;
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

- (void) updateProcedures: newProcedures
{
  [self replaceProceduresWithSameNamedOnesFrom: newProcedures];
  var composite = [Procedure compositeFrom: procedures];
  var separation = [composite filterByExclusion: animals];
  animals = [separation valueForKey: 'included'];
  animalsFreshlyExcluded = [separation valueForKey: 'excluded'];
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

- (CPArray) freshlyExcludedAnimalNames
{
  return [self nameListFrom: animalsFreshlyExcluded];
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

// Error checking

- (CPBoolean) containsExcludedAnimals
{
  var composite = [Procedure compositeFrom: procedures];

  animalsIncorrectlyPresent = [self intersect: [composite animalsThisProcedureExcludes]
                                         with: [self animals]];
  return [animalsIncorrectlyPresent count] > 0;
}

- (CPArray) animalsIncorrectlyPresent
{
  return animalsIncorrectlyPresent;
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


// TODO: I believe the implementation of CPSet set intersection is incorrect
// It checks object identity instead of isEquality.
- (CPArray) intersect: oneArray with: anotherArray
{
  var intersection = [];
  var enumerator = [oneArray objectEnumerator];
  var oneOne;
  while (oneOne = [enumerator nextObject])
  {
    if ([anotherArray containsObject: oneOne])
      [intersection addObject: oneOne];
  }
  return intersection;
}

-(void) replaceProceduresWithSameNamedOnesFrom: newProcedures
{
  var intersection = [];
  var newEnumerator, oldEnumerator;
  var newOne, oldOne;

  newEnumerator = [newProcedures objectEnumerator];
  while (newOne = [newEnumerator nextObject])
  {
    oldEnumerator = [procedures objectEnumerator];
    while(oldOne = [oldEnumerator nextObject])
    {
      if ([[oldOne name] isEqual: [newOne name]])
      {
        [intersection addObject: newOne];
      }
    }
  }
  procedures = intersection;
}

@end
