@import <AppKit/AppKit.j>

@implementation DateTimeEditingControl : CPView
{
  CPTextField dateField;
  CPButton morningButton;
  CPButton afternoonButton;
}

- (id) init
{
  self = [super initWithFrame: CGRectMakeZero()];

  [self placeFirstRow];
  [self placeSecondRow];

  return self;
}


- (void) setDate: aString morningState: aState
{
  [dateField setStringValue: aString];
  if (aState == CPOnState) 
  {
    [morningButton setState: CPOnState];
    // I expect above should turn all other radio buttons off. In Capp 0.7.1, 
    // it doesn't.
    [afternoonButton setState: CPOffState];
  }
  else
  {
    [afternoonButton setState: CPOnState];
    [morningButton setState: CPOffState];
  }
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

  [self addSubview: morningButton];
  [self addSubview: afternoonButton];
}

-(void) placeSecondRow
{
  x = 60;
  width = 80;
  var cancelButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 90, width, 30)];
  [cancelButton setTitle: "Cancel"];
  [self addSubview:cancelButton];
  //  controller.cancelButton = cancelButton;
  //  [cancelButton setAction: @selector(cancelReserving:)];
  x += width;

  x += 25;
  width = 80;
  var changeButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 90, width, 30)];
  [changeButton setTitle: "Change"];
  [self addSubview:changeButton];
  //  controller.changeButton = changeButton;
  //  [changeButton setAction: @selector(changeReserving:)];
}

@end
