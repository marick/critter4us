@import <Critter4Us/util/AnimalDescription.j>

@implementation _AnimalDescriptionTest : OJTestCase
{
}

- (void) testEquality
{
  [self assertTrue:  [[[AnimalDescription alloc] initWithName: 'match name'
						      species: 'match species'
							 note: 'match note'] isEqual:
                     [[AnimalDescription alloc] initWithName: 'match name'
						     species: 'match species'
							note: 'match note']]];


  [self assertFalse:  [[[AnimalDescription alloc] initWithName: 'UNmatch name'
						       species: 'match species'
							  note: 'match note'] isEqual:
                      [[AnimalDescription alloc] initWithName: 'match name'
						      species: 'match species'
							 note: 'match note']]];
  [self assertFalse:  [[[AnimalDescription alloc] initWithName: 'match name'
						       species: 'UNmatch species'
							  note: 'match note'] isEqual:
                      [[AnimalDescription alloc] initWithName: 'match name'
						      species: 'match species'
							 note: 'match note']]];
  [self assertFalse:  [[[AnimalDescription alloc] initWithName: 'match name'
						       species: 'match species'
							  note: 'UNmatch note'] isEqual:
                      [[AnimalDescription alloc] initWithName: 'match name'
						      species: 'match species'
							 note: 'match note']]];
}

- (void) test_can_make_animal_with_empty_name
{
  var actual = [AnimalDescription namelessWithSpecies: "species"
						 note: "note"];
  var expected = [[AnimalDescription alloc] initWithName: ""
						 species: "species"
						    note: "note"];

  [self assert: expected equals: actual];
}

@end
