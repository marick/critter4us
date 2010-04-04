@import <Critter4Us/util/TimesliceSummarizer.j>

@implementation _TimesliceSummarizerTest : OJTestCase
{
  TimesliceSummarizer summarizer;
}

- (void) setUp
{
  summarizer = [[TimesliceSummarizer alloc] init];
}

- (void) test_summary_works_for_singleton_times
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-10'
				 times: [ [Time morning] ]];
  [self assert: "on the morning of 2009-12-10"
        equals: [summarizer summarize: timeslice]];
}

- (void) test_displayed_timeslice_works_for_two_times
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-10'
				 times: [ [Time afternoon], [Time evening]]];
  [self assert: "on the afternoon and evening of 2009-12-10"
	equals: [summarizer summarize: timeslice]];
}


- (void) test_displayed_timeslice_works_for_three_times
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-10'
				 times: [ [Time afternoon], [Time evening], [Time morning]]];
  [self assert: "for the whole day on 2009-12-10"
	equals: [summarizer summarize: timeslice]];
}


- (void) test_summary_works_for_singleton_times_on_range_of_dates
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-11'
				 times: [ [Time morning] ]];
  [self assert: "on the mornings of 2009-12-10 through 2009-12-11"
        equals: [summarizer summarize: timeslice]];
}

- (void) test_displayed_timeslice_works_for_two_times
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-11'
				 times: [ [Time afternoon], [Time evening]]];
  [self assert: "on the afternoons and evenings of 2009-12-10 through 2009-12-11"
	equals: [summarizer summarize: timeslice]];
}


- (void) test_displayed_timeslice_works_for_three_times
{
  var timeslice = [Timeslice firstDate: '2009-12-10'
			      lastDate: '2009-12-11'
				 times: [ [Time afternoon], [Time evening], [Time morning]]];
  [self assert: "for the whole day on 2009-12-10 through 2009-12-11"
	equals: [summarizer summarize: timeslice]];
}


@end
