@import <Critter4Us/page-for-making-reservations/ReservationDataControllerPMR.j>
@import "ScenarioTestCase.j"

@implementation ReservationDataControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ReservationDataControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['courseField', 'instructorField',
                                        'dateField', 'morningButton',
                                        'beginButton', 'restartButton',
                                        'reserveButton',
                                        'linkToPreviousResults']];
}


@end
