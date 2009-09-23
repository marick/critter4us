@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/ToNetworkConverter.j>

@implementation ToNetworkConverterTest : OJTestCase
{
}

-(void) testTurnsNamedObjectsIntoNames
{
  var capp = [[NamedObject alloc] initWithName: 'proc'];
  [self assert: "proc" equals: [ToNetworkConverter convert: capp]];
}

-(void) testTurnsStringsIntoStrings
{
  var capp = "proc"
  [self assert: "proc" equals: [ToNetworkConverter convert: capp]];
}

-(void) testTurnsTimesIntoStrings
{
  var afternoon = [Time afternoon];
  var morning = [Time morning];
  [self assert: "morning" equals: [ToNetworkConverter convert: morning]];
  [self assert: "afternoon" equals: [ToNetworkConverter convert: afternoon]];
}

-(void) testConvertsEmptyArrayIntoEmptyArray
{
  var capp = [ ];
  [self assert: [] equals: [ToNetworkConverter convert: []]];
}

-(void) testConvertsArraysRecursively
{
  var capp = [ [[NamedObject alloc] initWithName: "1"], "2", [Time morning] ];
  [self assert: ["1", "2", "morning"] equals: [ToNetworkConverter convert: capp]];
}

-(void) testConvertsGroupIntoHash
{
  var betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var floating = [[Procedure alloc] initWithName: 'floating'];
  var accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];

  var capp = [[Group alloc] initWithProcedures: [floating, accupuncture] animals: [betsy]];
  var expected = {'animals':['betsy'], 'procedures':['floating', 'accupuncture']};
  var actual = [ToNetworkConverter convert: capp];
  [self assert: expected['animals'] equals: actual['animals']];
  [self assert: expected['procedures'] equals: actual['procedures']];
}

-(void) testConvertsDictionaryIntoHash
{
  var capp = [CPDictionary dictionary];
  [capp setValue: [Time morning] forKey: 'time'];

  var actual = [ToNetworkConverter convert: capp];
  
  [self assert: 'morning' equals: actual['time']];
}

@end
