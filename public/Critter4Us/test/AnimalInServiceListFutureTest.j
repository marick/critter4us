@import <Critter4Us/persistence/AnimalInServiceListFuture.j>
@import "ScenarioTestCase.j"

@implementation AnimalInServiceListFutureTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [AnimalInServiceListFuture alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [sut initWithRoute: 'irrelevant' notificationName: 'given notification'];
}

- (void) test_that_json_string_is_converted_to_Cappuccino_objects
{
  var given = '{"unused animals":["betsy","jake"]}';
  var actual = [sut convert: given];

  [self assert: 'betsy'
        equals: [actual valueForKey: 'unused animals'][0].name];
  [self assert: 'jake'
        equals: [actual valueForKey: 'unused animals'][1].name];
}

@end
