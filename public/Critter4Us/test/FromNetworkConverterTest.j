@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/FromNetworkConverter.j>

@implementation FromNetworkConverterTest : OJTestCase
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
  var converted = [FromNetworkConverter convert: input];
  [self assert: "output" equals: [converted valueForKey: 'miscellaneous']];
}

-(void) testConvertsMorningsToTimeObjects
{
  var input = { 'time' : 'morning' };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [Time morning] equals: [converted valueForKey: 'time']];
}

-(void) testConvertsAfternoonsToTimeObjects
{
  var input = { 'time' : 'afternoon' };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [Time afternoon] equals: [converted valueForKey: 'time']];
}

-(void) testConvertsEveningsToTimeObjects
{
  var input = { 'time' : 'evening' };
  var converted = [FromNetworkConverter convert: input];
  [self assert: [Time evening] equals: [converted valueForKey: 'time']];
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

- (void) testAProcedureListCanBeGivenAdditionalExclusions
{
  var input = {
    'procedures' : ['floating', 'venipuncture'],
    'exclusions' : {'floating' : ['betsy', 'jake'], 'venipuncture':[]},
    'kindMap' : { 'betsy':'cow', 'jake':'horse', 'fred':'goat'}
  };
  var extras = {'floating':['fred', 'jake'], 'venipuncture':['jake']};

  // TODO: move away from class methods
  var converter = [[FromNetworkConverter alloc] init];
  var converted = [converter convert: input withAddedExclusions: extras];
  var procedures = [converted valueForKey: 'procedures'];
  [self assert: 2 equals: [procedures count]];

  [self assert: 'floating' equals: [procedures[0] name]];
  // Note: for the moment, the duplicate exclusions are not a problem. 
  [self assert: [betsy, jake, fred, jake]
        equals: [procedures[0] animalsThisProcedureExcludes]];

  [self assert: 'venipuncture' equals: [procedures[1] name]];
  [self assert: [jake]
        equals: [procedures[1] animalsThisProcedureExcludes]];
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
