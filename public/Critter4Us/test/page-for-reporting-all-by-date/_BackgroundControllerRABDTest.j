@import <Critter4Us/page-for-reporting-all-by-date/BackgroundControllerRABD.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _BackgroundControllerRABDTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[BackgroundControllerRABD alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['timesliceControl']];
  [scenario sutHasDownwardCollaborators: ['primitivizer', 'httpMaker']];
}

- (void)test_reports_with_timeslice
{
  [scenario
    during: function() {
      [sut report: UnusedArgument];
    }
  behold: function() {
      [sut.timesliceControl shouldReceive: @selector(timeslice)
				andReturn: "a timeslice"];
      [sut.primitivizer shouldReceive: @selector(convert:)
				 with: "a timeslice"
			    andReturn: "primitive timeslice"];
      [sut.httpMaker shouldReceive: @selector(route_reportAllAnimalsAtTimeslice_html:)
			      with: "primitive timeslice"
			 andReturn: "route"
       ]; 
      // Can't check, but it should call window.open
    }];
}
@end
