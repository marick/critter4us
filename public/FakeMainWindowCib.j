@import "PersistentStore.j"
@import "MainWindowController.j"
@import "ProcedureInterfaceController.j"
@import "AnimalInterfaceController.j"

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
  var persistentStore = [[PersistentStore alloc] init];
  persistentStore.connection = [[Network alloc] init];

  var mainWindowController = [[MainWindowController alloc] init];
  mainWindowController.persistentStore = persistentStore;

  var procedureController = [[ProcedureInterfaceController alloc] init];
  procedureController.persistentStore = persistentStore;

  var animalController = [[AnimalInterfaceController alloc] init];
  animalController.persistentStore = persistentStore;


  theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
	       styleMask:CPBorderlessBridgeWindowMask];
  contentView = [theWindow contentView];

  mainWindowController.theWindow = theWindow;

  var dateField = [self makeDateEntry];
  [dateField setTarget: mainWindowController];
  [dateField setAction: @selector(newDate:)];

  var procedureTable = [self makeProcedureTable];
  procedureController.table = procedureTable;
  [procedureTable setDataSource: procedureController];
  [procedureTable setDelegate:procedureController];
  [procedureTable setTarget: procedureController];
  [procedureTable setAction: @selector(chooseProcedure:)];

  var animalTable = [self makeAnimalTable];
  animalController.table = animalTable;
  [animalTable setDataSource: animalController];
  [animalTable setDelegate:animalController];


  [procedureController awakeFromCib];
  [animalController awakeFromCib];
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
  [contentView addSubview:date];

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
