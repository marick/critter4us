@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/PrimitivesToModelObjectsConverter.j>

@implementation _PrimitivesToModelObjectsConverterTest : OJTestCase
{
  Animal betsy;
  Animal jake;
  Animal fred;
  Procedure floating;
  Procedure venipuncture;
}

-(void) setUp
{
  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  jake =  [[Animal alloc] initWithName: 'jake' kind: 'horse'];
  fred =  [[Animal alloc] initWithName: 'fred' kind: 'goat'];
  floating = [[Procedure alloc] initWithName: 'floating'];
  venipuncture = [[Procedure alloc] initWithName: 'venipuncture']}

}

-(void) testConvertsMiscellaneousKeyValuePairsByDoingNothing
{
  var input = { 'miscellaneous' : 'output' };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: "output" equals: [converted valueForKey: 'miscellaneous']];
}

-(void) test_converts_reservation_hash_to_dictionary
{
  var input = { 'reservation' : 5 };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: 5 equals: [converted valueForKey: 'reservation']];
}

-(void) testConvertsMorningsToTimeObjects
{
  var input = { 'time' : 'morning' };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: [Time morning] equals: [converted valueForKey: 'time']];
}

-(void) testConvertsAfternoonsToTimeObjects
{
  var input = { 'time' : 'afternoon' };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: [Time afternoon] equals: [converted valueForKey: 'time']];
}

-(void) testConvertsEveningsToTimeObjects
{
  var input = { 'time' : 'evening' };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: [Time evening] equals: [converted valueForKey: 'time']];
}

-(void) testConvertsAnimalNamesToAnimalObjects_RequiringKindMap
{
  var input = {
    'animal' : 'betsy',
    'kindMap' : { 'betsy':'cow'}
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: betsy
        equals: [converted valueForKey: 'animal']];
}

-(void) testConvertsAListOfAnimalNames
{
  var input = {
    'animals' : ['betsy', 'jake'],
    'kindMap' : { 'betsy':'cow', 'jake':'horse'}
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: [betsy, jake]
        equals: [converted valueForKey: 'animals']];
}

- (void) test_that_unused_animals_are_converted_to_named_objects
{
  var input = {"unused animals":["betsy"]};
  var converted = [PrimitivesToModelObjectsConverter convert: input];

  [self assert: [[[NamedObject alloc] initWithName: "betsy"]]
        equals: [converted valueForKey: 'unused animals']];
}


- (void) testAProcedureCanBeCreatedWithoutExclusionsFromJustName
{
  var input = {
    'procedure' : 'floating'
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: [[Procedure alloc] initWithName: 'floating']
        equals: [converted valueForKey: 'procedure']];
}


- (void) testAProcedureCanBeGivenExclusions
{
  var input = {
    'procedure' : 'floating',
    'allExclusions' : {'floating' : ['betsy', 'jake'], 'venipuncture':[]},
    'kindMap' : { 'betsy':'cow', 'jake':'horse'}
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: [[Procedure alloc] initWithName: 'floating' excluding: [betsy, jake]]
        equals: [converted valueForKey: 'procedure']];
}

- (void) test_that_exclusions_are_merged_to_form_all_exclusions
{
  var input = {
    'timeSensitiveExclusions' : {'floating' : ['betsy', 'jake'], 'venipuncture':[]},
    'timelessExclusions' : {'floating' : ['betsy'], 'venipuncture' : ['betsy']}
  };

  [PrimitivesToModelObjectsConverter convert: input];
  var newEntry = input['allExclusions'];

  // Note that we don't care about duplication or order
  [self assertTrue: [newEntry['floating'] containsObject: 'betsy']];
  [self assertTrue: [newEntry['floating'] containsObject: 'jake']];
  [self assertTrue: [newEntry['venipuncture'] containsObject: 'betsy']];
}


- (void) testAProcedureListCanBeCreatedAsWell
{
  var input = {
    'procedures' : ['floating', 'venipuncture']
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  [self assert: [floating, venipuncture]
        equals: [converted valueForKey: 'procedures']];
}


- (void) testAndTheProcedureListMayHaveExclusions
{
  var input = {
    'procedures' : ['floating', 'venipuncture'],
    'allExclusions' : {'floating' : ['betsy', 'jake'], 'venipuncture':[]},
    'kindMap' : { 'betsy':'cow', 'jake':'horse'}
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];
  var exclusions = [betsy, jake];
  var procedures = [
                    [[Procedure alloc] initWithName: 'floating' excluding: exclusions],
                    [[Procedure alloc] initWithName: 'venipuncture' excluding: []]
                    ];
  [self assert: procedures
        equals: [converted valueForKey: 'procedures']];
}

- (void) testCanCreateAGroup
{
  var input = {
    'group' : {'procedures' : ['floating', 'venipuncture'],
               'animals' : ['betsy', 'jake'] },
    'kindMap' : { 'betsy':'cow', 'jake':'horse'}
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];

  var animals = [betsy, jake];
  var procedures = [ floating, venipuncture];
  [self assert: [[Group alloc] initWithProcedures: procedures animals: animals]
        equals: [converted valueForKey: 'group']];
}

- (void) testCanCreateAListOfGroups
{
  var input = {
    'groups' : [ {'procedures' : ['floating'],
                  'animals' : ['betsy', 'jake'] },
                 {'procedures' : ['venipuncture'],
                  'animals' : ['jake']}],
    'kindMap' : { 'betsy':'cow', 'jake':'horse'}
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];

  var expected = [
                  [[Group alloc] initWithProcedures: [floating] animals: [betsy, jake]],
                  [[Group alloc] initWithProcedures: [venipuncture] animals: [jake]]
                  ];
  [self assert: expected
        equals: [converted valueForKey: 'groups']];
}

- (void) test_can_create_animal_descriptions
{
  var input = {
       'duplicates' : [ {'name':"betsy", 'species':'bovine', 'note':'cow'} ]
  };
  var converted = [PrimitivesToModelObjectsConverter convert: input];

  var expected = [
		  [[AnimalDescription alloc] initWithName: 'betsy'
						  species: 'bovine'
						     note: 'cow']
		  ];
  [self assert: expected
        equals: [converted valueForKey: 'duplicates']];
  
}


@end
