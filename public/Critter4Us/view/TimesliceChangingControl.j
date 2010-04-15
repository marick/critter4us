@import <AppKit/AppKit.j>
@import "../util/Time.j"
@import "../util/Constants.j"
@import "../util/Timeslice.j"
@import "TimesliceControl.j"

@implementation TimesliceChangingControl : CPView
{
  TimesliceControl timesliceControl;
  id target; // This could inherit from CPControl... is that overkill? 
  id container; 
  CPButton changeButton;
  CPButton cancelButton;
}

- (id) init
{
  self = [super initWithFrame: CGRectMakeZero()];

  timesliceControl = [[TimesliceControl alloc] initAtX: 10 y: 0];
  [self addSubview: timesliceControl];

  [self placeButtons];
  [cancelButton setTarget: self];
  [cancelButton setAction: @selector(forwardClick:)];
  [changeButton setTarget: self];
  [changeButton setAction: @selector(forwardClick:)];

  [NotificationCenter addObserver: self
			 selector: @selector(begin:)
			     name: UserWantsToReplaceTimeslice 
			   object: nil];

  return self;
}

- (void) begin: aNotification
{
  [timesliceControl setTimeslice: [aNotification object]];
  [container appear];
}


- (void) setTarget: anObject
{
  target = anObject;
}

- (CPString) timeslice
{
  return [timesliceControl timeslice];
}

- (void) forwardClick: sender
{
  [container disappear];
  if (sender == changeButton)
  {
    [target newTimesliceReady: [self timeslice]];
  }
}

- (void) setTimeslice: timeslice
{
  [timesliceControl setTimeslice: timeslice];
}

-(void) placeButtons
{
  x = 60;
  y = 30;
  width = 80;
  cancelButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 90, width, y)];
  [cancelButton setTitle: "Cancel"];
  [self addSubview:cancelButton];
  //  controller.cancelButton = cancelButton;
  //  [cancelButton setAction: @selector(cancelReserving:)];
  x += width;

  x += 25;
  width = 80;
  changeButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 90, width, y)];
  [changeButton setTitle: "Change"];
  [self addSubview:changeButton];
  //  controller.changeButton = changeButton;
  //  [changeButton setAction: @selector(changeReserving:)];
}

@end
