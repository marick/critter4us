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
    [animalSet addObjectsFromArray: [one animalsThisProcedureExcludes]]
  }
  return [[Procedure alloc] initWithName: "a composite procedure"
                               excluding: [animalSet allObjects]];
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
