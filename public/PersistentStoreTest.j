@import "PersistentStore.j"
@import "ScenarioTestCase.j"

@implementation PersistentStoreTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PersistentStore alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
 [scenario sutHasDownwardCollaborators: ['network']];
}


- (void)testFetchesAnimalNamesIntoArray
{
  [scenario
   during: function() {
      return [sut allAnimalNames];
   }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
       with: jsonURI(AllAnimalsRoute)
       andReturn: '{"animals":["betsy"]}'];
    }]
  [self assert: ['betsy'] equals: scenario.result];
}

- (void)testFetchesProcedureNamesIntoArray
{
  [scenario
   during: function() {
      return [sut allProcedureNames];
   }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
       with: jsonURI(AllProceduresRoute)
       andReturn: '{"procedures":["1", "2"]}'];
    }]
    [self assert: ['1', '2'] equals: scenario.result];
}

- (void)testFetchesJsonExclusions
{
  [scenario
   during: function() {
      return [sut exclusionsForDate:"2009-02-23"];
    }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
       with: jsonURI(ExclusionsRoute) + "?date=2009-02-23"
       andReturn: '{"exclusions":{"veniculture":["one"],"aquaculture":["2","3"]}}'];
    }
   ];
    
  var expected = [CPDictionary dictionaryWithJSObject: {"veniculture":["one"],"aquaculture":["2","3"]}];
  [self assertTrue: [expected isEqualToDictionary: scenario.result]];
}

-(void)xtestPostingOfReservation
{
  [network shouldReceive: @selector(POSTjsonForm:)];
}

@end
