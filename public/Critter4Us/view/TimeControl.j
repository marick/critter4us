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

- (Time) time
{
  if ([morningButton state] == CPOnState)
    return [Time morning];
  if ([afternoonButton state] == CPOnState)
    return [Time afternoon];
  if ([eveningButton state] == CPOnState)
    return [Time evening];
}

- (void) setTime: time
{
  if ([time isEqual: [Time morning]])
    [morningButton setState: CPOnState];
  if ([time isEqual: [Time afternoon]])
    [afternoonButton setState: CPOnState];
  if ([time isEqual: [Time evening]])
    [eveningButton setState: CPOnState];

  //  CPLog("morning: " + [morningButton state] + " afternoon: " + [afternoonButton state] + " evening: " + [eveningButton state]);
}


- (void) placeButtons
{
  var x = 10;
  var width = 90;
  morningButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 9, width, 20)];
  [morningButton setState:CPOnState];
  [morningButton setTitle:"morning"];
  
  afternoonButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 29, width, 20) radioGroup:[morningButton radioGroup]];
  [afternoonButton setTitle:"afternoon"];

  eveningButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 49, width, 20) radioGroup:[morningButton radioGroup]];
  [eveningButton setTitle:"evening"];

  [self addSubview: morningButton];
  [self addSubview: afternoonButton];
  [self addSubview: eveningButton];
}


@end
