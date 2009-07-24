@import <Foundation/CPObject.j>
@import "ProcedureTableController.j"
@import "AnimalTableController.j"


@implementation AppController : CPObject
{
  CPWindow theWindow;
  CPDateField date;
  CPButton button;
  CPObject animalTableController;
  CPObject procedureTableController;
  
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
  [date setStringValue: "2009-07-23"];

  [date setTarget: self];
  [date setAction: @selector(newDate:)];
  [contentView addSubview:date];

  [self makeProcedureTableIn: contentView];
  [self makeAnimalTableIn: contentView];

  [procedureTableController setHack: animalTableController];

  [theWindow orderFront:self];
}


- (void) makeProcedureTableIn:(CPView)contentView
{
  var tableView = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [[column headerView] setStringValue: @"procedure"];
  [[column headerView] sizeToFit];
  [column setWidth: 80];
  [tableView addTableColumn:column];

  procedureTableController = [[ProcedureTableController alloc] init];
  [tableView setDataSource: procedureTableController];
  [tableView setDelegate:procedureTableController];
  [tableView setTarget: procedureTableController];
  [tableView setAction: @selector(chooseProcedure:)];

  procedureTableController.table = tableView;

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(10,110,250,250)];
  [scrollView setDocumentView:tableView];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [contentView addSubview:scrollView];
}


- (void) makeAnimalTableIn:(CPView)contentView
{
  var tableView = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [column setWidth: 80];
  [tableView addTableColumn:column];

  animalTableController = [[AnimalTableController alloc] init];
  [tableView setDataSource: animalTableController];
  [tableView setDelegate:animalTableController];

  animalTableController.table = tableView;

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(400,110,250,250)];
  [scrollView setDocumentView:tableView];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [contentView addSubview:scrollView];
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
