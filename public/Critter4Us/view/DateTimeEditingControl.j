@import <AppKit/AppKit.j>
@import "../util/Time.j"
@import "../util/Constants.j"
@import "../util/Timeslice.j"
@import "TimesliceControl.j"

@implementation DateTimeEditingControl : CPView
{
  TimesliceControl timesliceControl;
  id target; // This could inherit from CPControl... is that overkill? 
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

  return self;
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
  if (sender == cancelButton)
  {
    [target forgetEditingTimeslice: self];
  }
  else
  {
    [target newTimesliceReady: self];
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
