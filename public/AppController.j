@import <Foundation/CPObject.j>
@import "ProcedureTableController.j"


@implementation AppController : CPObject
{
  CPWindow theWindow;
  CPDateField date;
  CPButton button;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
	       styleMask:CPBorderlessBridgeWindowMask];
  var contentView = [theWindow contentView];

  label = [[CPTextField alloc] initWithFrame:CGRectMake(10, 40, 250, 30)];
  [label setStringValue: "What date is your lab?"];
  [contentView addSubview:label];

  date = [[CPTextField alloc] initWithFrame:CGRectMake(10, 70, 250, 30)];
  [date setEditable:YES];
  [date setBezeled:YES];

  [date setTarget: self];
  [date setAction: @selector(newDate:)];
  [contentView addSubview:date];

  var tableView = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [[column headerView] setStringValue: @"procedure"];
  [[column headerView] sizeToFit];
  [column setWidth: 80];
  [tableView addTableColumn:column];
  var delegate = [[ProcedureTableController alloc] init];
  [tableView setDataSource: delegate];
  [tableView setDelegate:delegate];
  [tableView setTarget: delegate];
  [tableView setAction: @selector(chooseProcedure:)];

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(10,110,250,250)];
  [scrollView setDocumentView:tableView];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [contentView addSubview:scrollView];

  [theWindow orderFront:self];
}


- (void)newDate:(id)sender
{
}


-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
  alert(error);
}


-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
  //  var statusCode = [response statusCode];
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
  // receivedJsonData = [data objectFromJSON];
  alert(data);
}

@end
