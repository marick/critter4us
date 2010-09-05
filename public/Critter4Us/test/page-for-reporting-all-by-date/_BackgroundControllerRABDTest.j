@import <Critter4Us/page-for-reporting-all-by-date/BackgroundControllerRABD.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _BackgroundControllerRABDTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[BackgroundControllerRABD alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['dateControl']];
  [scenario sutHasDownwardCollaborators: ['primitivizer', 'httpMaker']];
}

- (void)test_reports_with_dates
{
  [scenario
    during: function() {
      [sut report: UnusedArgument];
    }
  behold: function() {
      var first = "2001-01-01";
      var last =  "2111-11-11";
	
      [sut.dateControl shouldReceive: @selector(firstDate)
				andReturn: first];
      [sut.dateControl shouldReceive: @selector(lastDate)
				andReturn: last];
      [sut.primitivizer shouldReceive: @selector(convert:)
				 with: first
			    andReturn: first];
      [sut.primitivizer shouldReceive: @selector(convert:)
				 with: last
			    andReturn: last];
      [sut.httpMaker shouldReceive: @selector(route_html_usageReportFirst:last:)
			      with: [first, last]
			 andReturn: "route"
       ]; 
      // Can't check, but it should call window.open
    }];
}
@end
