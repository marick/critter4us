@import <Foundation/Foundation.j>

@implementation Group : CPObject
{
  // In  0.7.1, this breaks:
  // CPArray procedures, animals;

  // Fix it by separating the variables:
  CPArray procedures;
  CPArray animals;
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

- (CPString) description
{
  return "<Group with" + [procedures description] + " and " + [animals description];
}

@end
