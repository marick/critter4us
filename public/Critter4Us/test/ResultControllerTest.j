@import <Critter4Us/controller/ResultController.j>
@import "ScenarioTestCase.j"

@implementation ResultControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ResultController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['link', 'containingView']];
}

-(void)testOfferingOfNewReservation
{
  [scenario
   sequence: function() {
      [sut offerReservationView: '33'];
    }
  means: function() {
      [sut.link shouldReceive: @selector(loadHTMLString:baseURL:)
       with: [function(arg) {
	    return arg.match(/\/reservation\/33/)
	  }, function(x) { return YES }] // TODO: Make this any "any".
       ]; 
    }  
   ];
}


@end
