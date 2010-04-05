@import <AppKit/AppKit.j>
@import "../util/Time.j"
@import "../util/Constants.j"
@import "../util/Timeslice.j"
@import "TimeControl.j"

@implementation DateTimeEditingControl : CPView
{
  CPTextField firstDateField;
  CPTextField lastDateField;
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

- (CPString) timeslice
{
  return [Timeslice firstDate: [firstDateField stringValue]
		     lastDate: [lastDateField stringValue]
			times: [timeControl times]];
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
  [firstDateField setStringValue: timeslice.firstDate];
  [lastDateField setStringValue: timeslice.lastDate];
  [timeControl setTimes: timeslice.times];
}


- (void) placeFirstRow
{
  var x = 25;
  var width = 40;

  var firstDateLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 22, width, 30)];
  [firstDateLabel setStringValue: "First: "];
  [self addSubview:firstDateLabel];

  var lastDateLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 49, width, 30)];
  [lastDateLabel setStringValue: "Final: "];
  [self addSubview:lastDateLabel];
  x += width;

  x += 10;
  width = 100;

  firstDateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 15, width, 30)];
  [firstDateField setEditable:YES];
  [firstDateField setBezeled:YES];
  [firstDateField setStringValue: "2010-"];
  [self addSubview:firstDateField];

  lastDateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 45, width, 30)];
  [lastDateField setEditable:YES];
  [lastDateField setBezeled:YES];
  [lastDateField setStringValue: "2010-"];
  [self addSubview:lastDateField];

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
