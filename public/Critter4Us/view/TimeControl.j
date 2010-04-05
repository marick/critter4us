@import <AppKit/AppKit.j>
@import "../util/Time.j"

@implementation TimeControl : CPView // TODO: Should be subclass of Control?
{
  CPButton morningButton;
  CPButton afternoonButton;
  CPButton eveningButton;
}

- initAtX: x y: y
{
  self = [super initWithFrame: CGRectMake(x, y, 100, 80)];
  [self placeButtons];
  return self;
}

- (CPArray) times
{
  var retval = []
  if ([morningButton state] == CPOnState)
    [retval addObject: [Time morning]];
  if ([afternoonButton state] == CPOnState)
    [retval addObject: [Time afternoon]];
  if ([eveningButton state] == CPOnState)
    [retval addObject: [Time evening]];
  return retval;
}

- (void) setTimes: source
{
  [morningButton setState: CPOffState];
  [afternoonButton setState: CPOffState];
  [eveningButton setState: CPOffState];
  
  if ([source containsObject: [Time morning]])
    [morningButton setState: CPOnState];
  if ([source containsObject: [Time afternoon]])
    [afternoonButton setState: CPOnState];
  if ([source containsObject: [Time evening]])
    [eveningButton setState: CPOnState];

  // CPLog("morning: " + [morningButton state] + " afternoon: " + [afternoonButton state] + " evening: " + [eveningButton state]);
}


- (void) placeButtons
{
  var x = 10;
  var width = 90;
  morningButton = [[CPCheckBox alloc] initWithFrame: CGRectMake(x, 9, width, 20)];
  [morningButton setTitle:"morning"];
  
  afternoonButton = [[CPCheckBox alloc] initWithFrame: CGRectMake(x, 29, width, 20)];
  [afternoonButton setTitle:"afternoon"];

  eveningButton = [[CPCheckBox alloc] initWithFrame: CGRectMake(x, 49, width, 20)];
  [eveningButton setTitle:"evening"];

  [self addSubview: morningButton];
  [self addSubview: afternoonButton];
  [self addSubview: eveningButton];
}


@end
