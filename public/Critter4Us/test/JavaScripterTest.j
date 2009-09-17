@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/JavaScripter.j>

@implementation JavaScripterTest : OJTestCase
{
}

-(void) testTurnsNamedObjectsIntoNames
{
  var capp = [[NamedObject alloc] initWithName: 'proc'];
  [self assert: "proc" equals: [JavaScripter parse: capp]];
}

-(void) testTurnsStringsIntoStrings
{
  var capp = "proc"
  [self assert: "proc" equals: [JavaScripter parse: capp]];
}

-(void) testTurnsTimesIntoStrings
{
  var afternoon = [Time afternoon];
  var morning = [Time morning];
  [self assert: "morning" equals: [JavaScripter parse: morning]];
  [self assert: "afternoon" equals: [JavaScripter parse: afternoon]];
}

-(void) testConvertsEmptyArrayIntoEmptyArray
{
  var capp = [ ];
  [self assert: [] equals: [JavaScripter parse: []]];
}

-(void) testParsesArraysRecursively
{
  var capp = [ [[NamedObject alloc] initWithName: "1"], "2", [Time morning] ];
  [self assert: ["1", "2", "morning"] equals: [JavaScripter parse: capp]];
}

-(void) testParsesGroupIntoHash
{
  var betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var floating = [[Procedure alloc] initWithName: 'floating'];
  var accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];

  var capp = [[Group alloc] initWithProcedures: [floating, accupuncture] animals: [betsy]];
  var expected = {'animals':['betsy'], 'procedures':['floating', 'accupuncture']};
  var actual = [JavaScripter parse: capp];
  [self assert: expected['animals'] equals: actual['animals']];
  [self assert: expected['procedures'] equals: actual['procedures']];
}

-(void) testParsesDictionaryIntoHash
{
  var capp = [CPDictionary dictionary];
  [capp setValue: [Time morning] forKey: 'time'];

  var actual = [JavaScripter parse: capp];
  
  [self assert: 'morning' equals: actual['time']];
}


@end
