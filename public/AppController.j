@import <Foundation/CPObject.j>
@import "ProcedureTableDelegate.j"


@implementation AppController : CPObject
{
  CPWindow theWindow;
  CPTextField cow1, cow2;
  CPDateField date;
  CPButton button;
  CPCollectionView possibleProcedures;
  CPArray procedures;
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
  var delegate = [[ProcedureTableDelegate alloc] init];
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




- (void)cowMe:(id)sender
{
  var request = [CPURLRequest requestWithURL: @"http://localhost:7000/json/cows"]; 
  var data = [CPURLConnection sendSynchronousRequest: request   
                              returningResponse:nil error:nil]; 
  var str = [data description]; 
  var json = [str objectFromJSON];
  [cow1 setStringValue: json["cows"][0]];
  [cow2 setStringValue: json["cows"][1]];
}

- (void)procedures:(id)sender
{
    cow1 = [[CPTextField alloc] initWithFrame:CGRectMake(100, 40, 250, 30)];
    [cow1 setEditable:YES];
    [cow1 setSelectable:YES];
    [cow1 setBezeled:YES];
    [contentView addSubview:cow1];

    cow2 = [[CPTextField alloc] initWithFrame:CGRectMake(100, 80, 250, 30)];
    [cow2 setEditable:YES];
    [cow2 setSelectable:YES];
    [cow2 setBezeled:YES];
    [contentView addSubview:cow2];

   button = [[CPButton alloc] initWithFrame:CGRectMake(100, 120, 80, 30)];
    [button setTitle:"Cow Me!"];
    [button setTarget:self];
    [button setAction:@selector(cowMe:)];
    [contentView addSubview:button];

 
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
