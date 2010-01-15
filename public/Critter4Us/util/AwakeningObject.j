@import "Constants.j"
@import "CritterObject.j"

@implementation AwakeningObject : CritterObject
{

  // For testing
  BOOL awakened;
}

- (void)awakeFromCib
{
  if (awakened) {
    alert([self description] + " has awoken twice. This may not be a problem, but should be reported.");
  }
  awakened = YES;
  [self setUpNotifications];
}

- (void) setUpNotifications
{
}

- (void) noChange
{
  // Used to answer the question "Did programmer forget to consider effect
  // on this object?" in the negative.
}


@end
