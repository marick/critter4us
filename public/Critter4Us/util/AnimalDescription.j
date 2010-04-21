
// Just a dumb holder for values.

@implementation AnimalDescription : CPObject
{
  String name;
  String species;
  String note;
}

+ (id) namelessWithSpecies: (String) aSpecies note: (String) aNote
{
  return [[self alloc] initWithName: "" species: aSpecies note: aNote];
}

- (id) initWithName: (String) aName species: (String) aSpecies note: (String) aNote
{
  self = [super init];
  name = aName;
  species = aSpecies;
  note = aNote;
  return self;
}

- (CPBoolean) isEqual: other
{
  if (! [name isEqual: other.name]) return NO;
  if (! [species isEqual: other.species]) return NO;
  if (! [note isEqual: other.note]) return NO;
  return YES;
}

- (id) hash
{
  hashval = (([name hash] << 5) ^ [note hash]) & 0xFFFFFF;
  return hashval;
}

- (CPString) description
{
  return "{animal description: " + name + "/" + species + "/" + note + "}";
}


@end
