@import "ResultController.j"
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


-(void) testInitialAppearance
{
  [scenario
   whileAwakening: function() {
      [self controlsWillBeMadeHidden];
    }];
}

-(void)testReceiptOfResult
{
  [scenario
   during: function() {
      [self sendNotification: NewReservationNews withObject:"YOW!"];
    }
  behold: function() {
      [self controlsWillBeMadeVisible];
      [sut.link shouldReceive: @selector(loadHTMLString:baseURL:)
       with: [function(arg) {
	    return arg.match(/\/reservation\/YOW!/)
	  }, function(x) { return YES }] // TODO: Make this any "any".
       ]; 
    }  
   ];
}


@end
