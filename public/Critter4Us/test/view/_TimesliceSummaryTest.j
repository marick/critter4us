@import <Critter4Us/view/TimesliceSummary.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _TimesliceSummaryTest : ScenarioTestCase
{
  TimesliceSummary sut;
}

- (void) setUp
{
  sut = [[TimesliceSummary alloc] initWithFrame: CGRectMakeZero()];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardCollaborators: ['summarizer', 'label']];
}


- (void) test_uses_summary
{
  [scenario
    during: function() {
      [sut summarize: "timeslice"];
    }
  behold: function() { 
      [sut.summarizer shouldReceive: @selector(summarize:)
                             with: "timeslice"
                        andReturn: "a summary"];
      [sut.label shouldReceive: @selector(setStringValue:)
                          with: "a summary."];
    }
   ];
}
