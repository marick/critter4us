@import "DualDateControl.j"
@import "TimeControl.j"

@implementation TimesliceControl : CPView
{
  DualDateControl dateControl;
  TimeControl timeControl;
}

- initAtX: x y: y
{
  self = [super initWithFrame: CGRectMake(x, y, 270, 100)];
  // [self setBackgroundColor: [CPColor redColor]];
  [self placeSubcontrolsAtX: x y: y];
  [dateControl setBoth: [Timeslice today]];
  return self;
}

- (void) placeSubcontrolsAtX: x y: y
{
  dateControl = [[DualDateControl alloc] initAtX: x y: 15]
  [self addSubview: dateControl];
  x += [dateControl bounds].size.width;
  
  timeControl = [[TimeControl alloc] initAtX: x y: 10];
  [self addSubview: timeControl];
}

- (void) setTimeslice: (Timeslice) timeslice
{
  [dateControl setFirst: timeslice.firstDate last: timeslice.lastDate];
  [timeControl setTimes: timeslice.times];
}

- (void) setTimes: (CPArray) times
{
  [timeControl setTimes: times]
}

- (Timeslice) timeslice
{
  var retval = [Timeslice firstDate: [dateControl firstDate]
			   lastDate: [dateControl lastDate]
			      times: [timeControl times]];
  return retval;
}

@end
