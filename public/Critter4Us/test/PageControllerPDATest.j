@import <Critter4Us/page-for-deleting-animals/PageControllerPDA.j>
@import "ScenarioTestCase.j"

@implementation PageControllerPDATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPDA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
}


@end
