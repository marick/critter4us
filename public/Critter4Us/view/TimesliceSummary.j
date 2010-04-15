@import <AppKit/AppKit.j>
@import "../util/TimesliceSummarizer.j"

@implementation TimesliceSummary : CPView
{
  TimesliceSummarizer summarizer;
  CPTextField label;
}

- (id) initWithFrame: frame
{
  self = [super initWithFrame: frame];
  //  [aView setBackgroundColor: [CPColor redColor]];

  label = [[CPTextField alloc] initWithFrame:CGRectMake(10, 35, 500, 30)];
  [self addSubview:label];
  [self setHidden: YES];
  [label setStringValue: "you should never see this"];

  summarizer = [[TimesliceSummarizer alloc] init];
  return self;
}


- (void) summarize: timeslice
{
  [label setStringValue: [summarizer summarize: timeslice]+"."];
}

@end
