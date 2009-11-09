@import <AppKit/AppKit.j>
@import "../util/Time.j"
@import "../util/Constants.j"
@import "TimeControl.j"

@implementation DateTimeEditingControl : CPView
{
  CPTextField dateField;
  TimeControl timeControl;
  id target; // This could inherit from CPControl... is that overkill? 
  CPButton changeButton;
  CPButton cancelButton;
}

- (id) init
{
  self = [super initWithFrame: CGRectMakeZero()];

  [self placeFirstRow];
  [self placeSecondRow];
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

- (CPString) date
{
  return [dateField stringValue];
}

- (Time) time
{
  return [timeControl time];
}

- (void) forwardClick: sender
{
  if (sender == cancelButton)
  {
    [target forgetEditingDateTime: self];
  }
  else
  {
    [target newDateTimeValuesReady: self];
  }
}


- (void) setDate: aString time: time
{
  [dateField setStringValue: aString];
  [timeControl setTime: time];
}


- (void) placeFirstRow
{
  var x = 25;
  var width = 40;
  var onLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 37, width, 30)];
  [onLabel setStringValue: "Date: "];
  [self addSubview:onLabel];
  x += width;

  x += 10;
  width = 100;
  dateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 30, width, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-"];
  [self addSubview:dateField];
  x += width;

  timeControl = [[TimeControl alloc] initAtX: x y: 10];
  [self addSubview: timeControl];
}

-(void) placeSecondRow
{
  x = 60;
  width = 80;
  cancelButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 90, width, 30)];
  [cancelButton setTitle: "Cancel"];
  [self addSubview:cancelButton];
  //  controller.cancelButton = cancelButton;
  //  [cancelButton setAction: @selector(cancelReserving:)];
  x += width;

  x += 25;
  width = 80;
  changeButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 90, width, 30)];
  [changeButton setTitle: "Change"];
  [self addSubview:changeButton];
  //  controller.changeButton = changeButton;
  //  [changeButton setAction: @selector(changeReserving:)];
}

@end
