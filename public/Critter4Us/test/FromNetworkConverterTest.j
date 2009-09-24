@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/FromNetworkConverter.j>

@implementation FromNetworkConverterTest : OJTestCase
{
  Animal betsy;
  Animal jake;
  Procedure floating;
  Procedure venipuncture;
}

-(void) setUp
{
  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  jake =  [[Animal alloc] initWithName: 'jake' kind: 'horse'];
  floating = [[Procedure alloc] initWithName: 'floating'];
  venipuncture = [[Procedure alloc] initWithName: 'venipuncture']}

}

-(void) testConvertsMiscellaneousKeyValuePairsByDoingNothing
{
  var input = { 'miscellaneous' : 'output' };
  var converted = [FromNetworkConverter convert: input];
  [self assert: "output" equals: [converted valueForKey: 'miscellaneous']];
}


-(void) testConvertsFalseMorningsToTimeObjects
{
  var input = { 'morning' : false };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [Time afternoon] equals: [converted valueForKey: 'time']];
}

-(void) testConvertsTrueMorningsToTimeObjects
{
  var input = { 'morning' : true };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [Time morning] equals: [converted valueForKey: 'time']];
}

-(void) testConvertsAnimalNamesToAnimalObjects_RequiringKindMap
{
  var input = {
    'animal' : 'betsy',
    'kindMap' : { 'betsy':'cow'}
  };
  var converted = [FromNetworkConverter convert: input];
  [self assert: betsy
        equals: [converted valueForKey: 'animal']];
}

-(void) testConvertsAListOfAnimalNames
{
  var input = {
    'animals' : ['betsy', 'jake'],
    'kindMap' : { 'betsy':'cow', 'jake':'horse'}
  };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [betsy, jake]
        equals: [converted valueForKey: 'animals']];
}

- (void) testAProcedureCanBeCreatedWithoutExclusionsFromJustName
{
  var input = {
    'procedure' : 'floating'
  };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [[Procedure alloc] initWithName: 'floating']
        equals: [converted valueForKey: 'procedure']];
}


- (void) testAProcedureCanBeGivenExclusions
{
  var input = {
    'procedure' : 'floating',
    'exclusions' : {'floating' : ['betsy', 'jake'], 'venipuncture':[]},
    'kindMap' : { 'betsy':'cow', 'jake':'horse'}
  };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [[Procedure alloc] initWithName: 'floating' excluding: [betsy, jake]]
        equals: [converted valueForKey: 'procedure']];
}


- (void) testAProcedureListCanBeCreatedAsWell
{
  var input = {
    'procedures' : ['floating', 'venipuncture']
  };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [floating, venipuncture]
        equals: [converted valueForKey: 'procedures']];
}


- (void) testAndTheProcedureListMayHaveExclusions
{
  var input = {
    'procedures' : ['floating', 'venipuncture'],
    'exclusions' : {'floating' : ['betsy', 'jake'], 'venipuncture':[]},
    'kindMap' : { 'betsy':'cow', 'jake':'horse'}
  };
  var converted = [FromNetworkConverter convert: input];
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
  var converted = [FromNetworkConverter convert: input];

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
  var converted = [FromNetworkConverter convert: input];

  var expected = [
                  [[Group alloc] initWithProcedures: [floating] animals: [betsy, jake]],
                  [[Group alloc] initWithProcedures: [venipuncture] animals: [jake]]
                  ];
  [self assert: expected
        equals: [converted valueForKey: 'groups']];
}


@end