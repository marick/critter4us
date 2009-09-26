@import <AppKit/AppKit.j>

@implementation DateChangingPanel : CPPanel
{
}

- (id) initAtX: x y: y
{
  var rect = CGRectMake(x, y, 300, 150);
  self = [self initWithContentRect: rect styleMask: CPTitledWindowMask];
  [self setFloatingPanel:YES];
  [self setTitle:@"Change Date and Time"];
  [self orderFront: self]; // TODO: delete when page layout done.

  var contentView = [self contentView];
  [self putFirstRowOn: contentView];
  [self putSecondRowOn: contentView];

  return self;
}


- (void) putFirstRowOn: contentView
{
  var x = 25;
  var width = 40;
  var onLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 37, width, 30)];
  [onLabel setStringValue: "Date: "];
  [contentView addSubview:onLabel];
  x += width;

  x += 10;
  width = 100;
  dateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 30, width, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-"];
  [contentView addSubview:dateField];
  x += width;
  

  x += 10;
  width = 90;
  var morningButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 29, width, 20)];
  [morningButton setState:CPOnState];
  [morningButton setTitle:"morning"];
  
  var afternoonButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 49, width, 20) radioGroup:[morningButton radioGroup]];
  [afternoonButton setTitle:"afternoon"];

  [contentView addSubview: morningButton];
  [contentView addSubview: afternoonButton];
}

-(void) putSecondRowOn: contentView
{
  x = 60;
  width = 80;
  var cancelButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 90, width, 30)];
  [cancelButton setTitle: "Cancel"];
  [contentView addSubview:cancelButton];
  //  controller.cancelButton = cancelButton;
  //  [cancelButton setAction: @selector(cancelReserving:)];
  x += width;

  x += 25;
  width = 80;
  var changeButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 90, width, 30)];
  [changeButton setTitle: "Change"];
  [contentView addSubview:changeButton];
  //  controller.changeButton = changeButton;
  //  [changeButton setAction: @selector(changeReserving:)];
}

@end
