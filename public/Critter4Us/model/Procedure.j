@import <Foundation/Foundation.j>
@import "NamedObject.j"

@implementation Procedure : NamedObject
{
  CPArray animalsThisProcedureExcludes;
}

+(Procedure) compositeFrom: (CPArray) procedures
{
  var animalSet = [CPMutableSet set];
  for(var i=0; i < [procedures count]; i++)
  {
    var one = procedures[i];
    var excluded = [one animalsThisProcedureExcludes];
    [animalSet addObjectsFromArray: excluded];
  }
  var composite = [[Procedure alloc] initWithName: "a composite procedure"
                                        excluding: [animalSet allObjects]];
  return composite;
}

-(id) initWithName: aName
{
  return [self initWithName: aName excluding: []];
}

-(id) initWithName: aName excluding: animals
{
  self = [super initWithName: aName];
  animalsThisProcedureExcludes = animals;
  return self;
}

-(CPArray) animalsThisProcedureExcludes
{
  return animalsThisProcedureExcludes;
}


-(CPBoolean) excludes: anAnimal
{
  return [[self animalsThisProcedureExcludes] containsObject: anAnimal];
}

- (CPDictionary) filterByExclusion: animals
{
  var included = [];
  var excluded = [];

  var enumerator = [animals objectEnumerator];
  var one;
  while (one = [enumerator nextObject])
  {
    if ([self excludes: one])
      [excluded addObject: one];
    else
      [included addObject: one]
  }
  return [CPDictionary dictionaryWithObjects: [included, excluded]
                                     forKeys: ['included', 'excluded']];
  
}

-(CPBoolean) isEqual: other
{
  if (! [super isEqual: other]) return NO;
  return [[self animalsThisProcedureExcludes] isEqual: [other animalsThisProcedureExcludes]];
}

-(CPString) longDescription
{
  return [super description] + " excluding " + [[self animalsThisProcedureExcludes] description];
}
@end
