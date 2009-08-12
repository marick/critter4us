@import "ControllerCoordinator.j"
@import "ScenarioTestCase.j"

@implementation ControllerCoordinatorTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ControllerCoordinator alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['resultController', 'reservationController', 'animalController', 'procedureController', 'courseSessionController']];
}

-(void) testInitialAppearance
{
  [scenario
   whileAwakening: function() {
      [sut.courseSessionController shouldReceive: @selector(makeViewsAcceptData)];
      [sut.animalController shouldReceive: @selector(hideViews)];
      [sut.procedureController shouldReceive: @selector(hideViews)];
      [sut.reservationController shouldReceive: @selector(hideViews)];
      [sut.resultController shouldReceive: @selector(hideViews)];
    }];
}



@end
