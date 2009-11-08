@import <AppKit/AppKit.j>
@import "../util/Time.j"
@import "../util/Constants.j"

@implementation DateTimeEditingControl : CPView
{
  CPTextField dateField;
  CPButton morningButton;
  CPButton afternoonButton;
  CPButton eveningButton;
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

- (Time) time  // TODO: Same as ReservationDataControllerPMR#timeFromRadio
{
  if ([morningButton state] == CPOnState)
    return [Time morning];
  if ([afternoonButton state] == CPOnState)
    return [Time afternoon];
  if ([eveningButton state] == CPOnState)
    return [Time evening];
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


// TODO: Same as ReservationDataController#setRadiosTo.
- (void) setDate: aString time: time
{
  [dateField setStringValue: aString];

  // TODO: Is this necessary to turn all other radio buttons off? 
  // Seems to be in Capp 0.7.1
  [morningButton setState: CPOffState];  
  [afternoonButton setState: CPOffState];
  [eveningButton setState: CPOffState];

  if ([time isEqual: [Time morning]])
    [morningButton setState: CPOnState];
  if ([time isEqual: [Time afternoon]])
    [afternoonButton setState: CPOnState];
  if ([time isEqual: [Time evening]])
    [eveningButton setState: CPOnState];

  //  CPLog("morning: " + [morningButton state] + " afternoon: " + [afternoonButton state] + " evening: " + [eveningButton state]);
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
  

  x += 10;
  width = 90;
  morningButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 29, width, 20)];
  [morningButton setState:CPOnState];
  [morningButton setTitle:"morning"];
  
  afternoonButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 49, width, 20) radioGroup:[morningButton radioGroup]];
  [afternoonButton setTitle:"afternoon"];

  eveningButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 69, width, 20) radioGroup:[morningButton radioGroup]];
  [eveningButton setTitle:"evening"];

  [self addSubview: morningButton];
  [self addSubview: afternoonButton];
  [self addSubview: eveningButton];
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
