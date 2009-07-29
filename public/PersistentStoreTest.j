@import "PersistentStore.j"
@import "Mock.j"

@implementation PersistentStoreTest : OJTestCase
{
  PersistentStore store;
  Mock network;
}

- (void)setUp
{
  store = [[PersistentStore alloc] init];
  network = [[Mock alloc] init];
  store.connection = network;
}

- (void)testParsesJsonIntoAnimalList
{
  [network shouldReceive: @selector(jsonStringFromRequest:)
   andReturn: '{"animals":["betsy"]}'];
  
  [self assert: ['betsy'] equals: [store allAnimalNames]];
}

- (void)testParsesJsonIntoExclusionHash
{
  [network shouldReceive: @selector(jsonStringFromRequest:)
   andReturn: '{"exclusions":{"veniculture":["one"],"aquaculture":["2","3"]}}'];
  
  actual = [store exclusionsForDate:"2008-02-12"];
  [self assert: 2 equals: [[actual allKeys] count]];
  [self assert: ["one"]
                equals: [actual objectForKey: "veniculture"]];
  [self assert: ["2","3"]
                equals: [actual objectForKey: "aquaculture"]];

}



@end
