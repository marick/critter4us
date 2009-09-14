@import <Critter4Us/page-for-making-reservations/ProcedureControllerPMR.j>
@import <Critter4US/model/Procedure.j>
@import "ScenarioTestCase.j"

@implementation ProcedureControllerPMRTest : ScenarioTestCase
{
  Procedure floating, milking, dancing;
}

- (void)setUp
{
  sut = [[ProcedureControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['available', 'used']];

  floating = [[Procedure alloc] initWithName: 'floating'];
  milking = [[Procedure alloc] initWithName: 'milking'];
  dancing = [[Procedure alloc] initWithName: 'dancing'];
}


- (void)testChoosingAProcedureAnnouncesWhichProceduresHaveBeenChosen
{
  [scenario
   previousAction: function() {
      [sut beginUsing: [floating, milking, dancing]];
    }
  during: function() {
      [sut objectsRemoved: [floating] fromList: sut.available];
    }
  behold: function() {
      [sut.used shouldReceive: @selector(content) andReturn: [floating]];
      [self listenersWillReceiveNotification: ProceduresChosenNews
                            containingObject: [floating]];
    }];
}

@end	
