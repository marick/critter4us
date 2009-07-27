@import "MainWindowController.j"
@import "ProcedureTableController.j"
@import "AnimalTableController.j"

@implementation FakeMainWindowCib : CPObject
{
  CPWindow theWindow;
  CPView contentView;
}

+ (void)load
{
  [[[FakeMainWindowCib alloc] init] load];
}

- (void)load
{
  var mainWindowController = [[MainWindowController alloc] init];
  var procedureTableController = [[ProcedureTableController alloc] init];
  var animalTableController = [[AnimalTableController alloc] init];

  theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
	       styleMask:CPBorderlessBridgeWindowMask];
  contentView = [theWindow contentView];

  mainWindowController.theWindow = theWindow;

  var dateField = [self makeDateEntry];
  [dateField setTarget: mainWindowController];
  [dateField setAction: @selector(newDate:)];

  var procedureTable = [self makeProcedureTable];
  procedureTableController.table = procedureTable;
  [procedureTable setDataSource: procedureTableController];
  [procedureTable setDelegate:procedureTableController];
  [procedureTable setTarget: procedureTableController];
  [procedureTable setAction: @selector(chooseProcedure:)];

  var animalTable = [self makeAnimalTable];
  animalTableController.table = animalTable;
  [animalTable setDataSource: animalTableController];
  [animalTable setDelegate:animalTableController];


  [procedureTableController awakeFromCib];
  [animalTableController awakeFromCib];
  [mainWindowController awakeFromCib];

  [theWindow orderFront:self];
}

- (CPTextField) makeDateEntry
{
  label = [[CPTextField alloc] initWithFrame:CGRectMake(10, 40, 250, 30)];
  [label setStringValue: "What date is your lab?"];
  [contentView addSubview:label];

  date = [[CPTextField alloc] initWithFrame:CGRectMake(10, 70, 250, 30)];
  [date setEditable:YES];
  [date setBezeled:YES];
  [date setStringValue: "2009-07-23"];

  return date;
}

- (CPTableView) makeProcedureTable
{
  var tableView = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [[column headerView] setStringValue: @"procedure"];
  [[column headerView] sizeToFit];
  [column setWidth: 80];
  [tableView addTableColumn:column];

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(10,110,250,250)];
  [scrollView setDocumentView:tableView];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [contentView addSubview:scrollView];

  return tableView;
}


- (CPTableView) makeAnimalTable
{
  var tableView = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [column setWidth: 80];
  [tableView addTableColumn:column];

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(400,110,250,250)];
  [scrollView setDocumentView:tableView];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [contentView addSubview:scrollView];

  return tableView;
}
