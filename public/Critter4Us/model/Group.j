@import <Foundation/Foundation.j>

@implementation Group : CPObject
{
  // In  0.7.1, this breaks:
  // CPArray procedures, animals;

  // Fix it by separating the variables:
  CPArray procedures;
  CPArray animals;
}

- (void) initWithProcedures: someProcedures animals: someAnimals
{
  self = [super init];
  procedures = someProcedures;
  animals = someAnimals;
  return self;
}

- (void) procedures
{
  return procedures;
}

- (void) animals
{
  return animals;
}

- (void) name
{
  return [self procedureNames].join(', ');
}

- (void) procedureNames
{
  var retval = [];
  var enumerator = [procedures objectEnumerator];
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
