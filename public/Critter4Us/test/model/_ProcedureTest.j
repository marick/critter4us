@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Animal.j>

@implementation _ProcedureTest : OJTestCase
{
  Animal oneAnimal, another, aThird, duplicate;
}

- (void) setUp
{
  oneAnimal = [[Animal alloc] initWithName: 'one' kind: 'b'];
  another = [[Animal alloc] initWithName: 'another' kind: 'b'];
  aThird = [[Animal alloc] initWithName: 'a third' kind: 'b'];
  duplicate = [[Animal alloc] initWithName: [oneAnimal name]
                                      kind: [oneAnimal kind]];

}


- (void) testDefaultProcedureHasNoExclusions
{
  var proc = [[Procedure alloc] initWithName: "proc"];
  [self assert: [] equals: [proc animalsThisProcedureExcludes]];
}

- (void) testCanCreateWithExclusions
{
  var toExclude = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var proc = [[Procedure alloc] initWithName: "proc" excluding: [toExclude]];
  [self assert: [toExclude] equals: [proc animalsThisProcedureExcludes]];
}

- (void) testAggregateProceduresAggregateExcludedAnimalsFromMultipleProcedures
{
  var oneProc = [[Procedure alloc] initWithName: 'one' 
                                      excluding: [oneAnimal]];
  var twoProc = [[Procedure alloc] initWithName: 'two'
                                      excluding: [another, aThird]];

  var composite = [Procedure compositeFrom: [oneProc, twoProc]];
  var actual = [CPSet setWithArray: [composite animalsThisProcedureExcludes]];
  var expected = [CPSet setWithArray: [oneAnimal, another, aThird]];
  [self assertTrue: [expected isEqualToSet: actual]];
}

- (void) testAggregateProceduresDoNotIncludeDuplicates
{
  var oneProc = [[Procedure alloc] initWithName: 'one' 
                                      excluding: [oneAnimal]];
  var twoProc = [[Procedure alloc] initWithName: 'two'
                                      excluding: [duplicate]];

  var composite = [Procedure compositeFrom: [oneProc, twoProc]];
  var actual = [CPSet setWithArray: [composite animalsThisProcedureExcludes]];
  var expected = [CPSet setWithArray: [duplicate]];
  [self assertTrue: [expected isEqualToSet: actual]];
}

- (void) testProceduresCanAnswerIfAnAnimalIsExcluded
{
  var procedure = [[Procedure alloc] initWithName: "name"
                                        excluding: [oneAnimal]];

  [self assertTrue: [procedure excludes: duplicate]];
  [self assertFalse: [procedure excludes: aThird]];
}


- (void) testProceduresCanPartitionAnimalsIntoIncludedAndExcluded
{
  var procedure = [[Procedure alloc] initWithName: "name"
                                        excluding: [oneAnimal, aThird]];

  var dictionary = [procedure filterByExclusion: [oneAnimal, another, aThird]];
  
  [self assert: [oneAnimal, aThird] equals: [dictionary valueForKey: 'excluded']];
  [self assert: [another] equals: [dictionary valueForKey: 'included']];
}



@end
