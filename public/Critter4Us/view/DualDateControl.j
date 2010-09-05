@import <AppKit/AppKit.j>
@import "../util/Timeslice.j"

@implementation DualDateControl : CPView // TODO: Should be subclass of Control?
{
  CPTextField firstDateField;
  CPTextField lastDateField;
  CPBoolean lastEdited; 
}

- initAtX: x y: y
{
  self = [super initWithFrame: CGRectMake(x, y, 170, 80)];
  // [self setBackgroundColor: [CPColor redColor]];
  [self placeFields];
  [self setBoth: [Timeslice today]];
  lastEdited = NO;
  return self;
}

- (CPString) firstDate
{
  return [firstDateField stringValue];
}

- (CPString) lastDate
{
  return [lastDateField stringValue];
}

- (void) setFirst: firstDate last: lastDate
{
  [firstDateField setStringValue: firstDate];
  [lastDateField setStringValue: lastDate];
  lastEdited = (! [firstDate isEqualToString: lastDate]);
}

- (void) setBoth: date
{
  [self setFirst: date last: date];
}

- (void) controlTextDidChange: aNotification
{
  if ([aNotification object] == lastDateField) {
    lastEdited = YES;
    return;
  }
  if (lastEdited) return;
  
  [lastDateField setStringValue: [firstDateField stringValue]];
}

- (void) placeFields
{
  x = 0;
  width = 60;
  var firstDateLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 5, width, 30)];
  [firstDateLabel setStringValue: "first date: "];

  var lastDateLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 40, width, 30)];
  [lastDateLabel setStringValue: "final date: "];

  x += width;

  width = 100;
  firstDateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 0, width, 30)];
  [firstDateField setEditable:YES];
  [firstDateField setBezeled:YES];
  [firstDateField setDelegate: self];

  lastDateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 35, width, 30)];
  [lastDateField setEditable:YES];
  [lastDateField setBezeled:YES];
  [lastDateField setDelegate: self];

  [firstDateField setNextKeyView: lastDateField];
  [lastDateField setNextKeyView: firstDateField];

  [self addSubview:firstDateLabel];
  [self addSubview:lastDateLabel];
  [self addSubview:firstDateField];
  [self addSubview:lastDateField];
}

@end
