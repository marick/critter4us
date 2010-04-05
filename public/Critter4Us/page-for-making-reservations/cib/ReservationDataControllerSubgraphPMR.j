@import "../../cib/Subgraph.j"
@import "../ReservationDataControllerPMR.j"
@import "../../view/TimeControl.j"
@import "../../view/DateTimeEditingPanel.j"
@import "../../view/DateTimeEditingControl.j"
@import "../../controller/PanelController.j"
@import "../../util/Constants.j"


@implementation ReservationDataControllerSubgraphPMR : Subgraph
{
  ReservationDataControllerPMR controller;

  CPTextField instructorField;
  CPTextField courseField;
  CPTextField firstDateField;
  CPTextField lastDateField;
  CPRadio afternoonButton; 

  CPButton dateTimeButton;
  PanelController panelController;
  ReservationDataControllerPMR controller;
  // There are others but no need to make them instance vars.
}


- (id) initOnPage: pageView
{
  self = [super init];
  
  controller = [self custom: [[ReservationDataControllerPMR alloc] init]];
  [self drawControlsOnPage: pageView];
  [self dateTimeEditingPanel];
  return self;
}

- (void) connectOutlets
{
  // No need.
}



-(id) drawControlsOnPage: pageView
{  
  // TODO: get rid of at least some of thest manifest constants.

  var y = 40
  var x = 10;
  var width = 45
  var courseLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, y+5, width, 30)];
  [courseLabel setStringValue: "Course: "];
  [pageView addSubview:courseLabel];
  x += width;

  width = 100;
  courseField = [[CPTextField alloc] initWithFrame:CGRectMake(x, y, width, 30)];
  [courseField setEditable:YES];
  [courseField setBezeled:YES];
  [pageView addSubview:courseField];
  controller.courseField = courseField;
  x+= width;

  x += 10;
  width = 90;
  var instructorLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, y+5, width, 30)];
  [instructorLabel setStringValue: "Instructor NetID: "];
  [pageView addSubview:instructorLabel];
  x += width;

  width = 100;
  instructorField = [[CPTextField alloc] initWithFrame:CGRectMake(x, y, width, 30)];
  [instructorField setEditable:YES];
  [instructorField setBezeled:YES];
  [pageView addSubview:instructorField];
  controller.instructorField = instructorField;
  x += width;

  var dateGatheringView = [[CPView alloc] initWithFrame:CGRectMake(x, y-30, 370, 100)];
  [self addDateGatheringControlsTo: dateGatheringView];
  [pageView addSubview:dateGatheringView];
  [dateGatheringView setHidden: NO];
  controller.dateGatheringView = dateGatheringView;

  var majorModificationView = [[CPView alloc]
				initWithFrame:CGRectMake([pageView bounds].size.width - 300,
							 y, 300, 70)]
  [self addMajorModificationControlsTo: majorModificationView];
  [pageView addSubview:majorModificationView];
  [majorModificationView setHidden: YES];
  controller.majorModificationView = majorModificationView;

  var dateDisplayingView = [[CPView alloc] initWithFrame:CGRectMake(x, y-30, 450, 100)];
  [self addDateDisplayingControlsTo: dateDisplayingView];
  [pageView addSubview:dateDisplayingView];
  [dateDisplayingView setHidden: YES];
  controller.dateDisplayingView = dateDisplayingView;

  var placeForLink = x + 280;

  var reserveButton = [[CPButton alloc] initWithFrame:CGRectMake(320, 410, 160, 30)];
  [reserveButton setTitle: "Finish this Reservation"];
  [reserveButton setHidden: YES];
  [pageView addSubview:reserveButton];
  controller.reserveButton = reserveButton;
  [reserveButton setTarget: controller];
  [reserveButton setAction: @selector(makeReservation:)];


  var resultsView = [[CPView alloc] initWithFrame: CGRectMake(placeForLink,95,500,200)];
  [resultsView setHidden: YES];
  [pageView addSubview: resultsView];
  controller.previousResultsView = resultsView;

  var webView = [[CPWebView alloc] initWithFrame: CGRectMake(0,0,500,300)];
  [resultsView addSubview: webView];
  controller.linkToPreviousResults = webView;

  var copyButton = [[CPButton alloc] initWithFrame: CGRectMake(5, 40, 200, 30)];
  [copyButton setTitle: "Copy this Reservation"];
  [copyButton setTarget: controller];
  [copyButton setAction: @selector(copyPreviousReservation:)];
  [resultsView addSubview: copyButton];
  controller.copyButton = copyButton;

  // Temporary for testing
  [instructorField setStringValue: "morin"];
  [courseField setStringValue: "VM333"];
  [firstDateField setStringValue: [Timeslice today]];

  // TODO: do this with notifications.
  [courseField setNextKeyView: firstDateField];
  [firstDateField setNextKeyView: afternoonButton];

  // Doesn't work.
  //  [theWindow setDefaultButton: goButton];
  //  [theWindow enableKeyEquivalentForDefaultButton];
}

  
- (void) addMajorModificationControlsTo: aView
{
  x = [aView bounds].size.width - 80 - 20
  var restartButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 0, 80, 30)];
  [restartButton setTitle: "Start Over"];
  [restartButton setHidden: NO];
  [aView addSubview:restartButton];
  [restartButton setTarget: controller];
  [restartButton setAction: @selector(abandonReservation:)];


  x -= 80
  dateTimeButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 35, 160, 30)];
  [dateTimeButton setTitle: "Change Date or Time"];
  [dateTimeButton setHidden: NO];
  [aView addSubview:dateTimeButton];
  [dateTimeButton setTarget: controller];
  [dateTimeButton setAction: @selector(startDestructivelyEditingTimeslice:)];
}
    
- (void) addDateGatheringControlsTo: aView
{
  //  [aView setBackgroundColor: [CPColor redColor]];
  
  x = 10;
  width = 60;
  var firstDateLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 20, width, 30)];
  [firstDateLabel setStringValue: "first date: "];
  [aView addSubview:firstDateLabel];

  var lastDateLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 55, width, 30)];
  [lastDateLabel setStringValue: "final date: "];
  [aView addSubview:lastDateLabel];

  x += width;

  width = 100;
  firstDateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 15, width, 30)];
  [firstDateField setEditable:YES];
  [firstDateField setBezeled:YES];
  [firstDateField setStringValue: "2010-"];
  [aView addSubview:firstDateField];
  controller.firstDateField = firstDateField;

  lastDateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 50, width, 30)];
  [lastDateField setEditable:YES];
  [lastDateField setBezeled:YES];
  [lastDateField setStringValue: ""];
  [aView addSubview:lastDateField];
  controller.lastDateField = lastDateField;

  x += width;

  
  timeControl = [[TimeControl alloc] initAtX: x y: 10];
  [aView addSubview: timeControl];
  controller.timeControl = timeControl;
  x += [timeControl frame].size.width;
    
  x += 15
  width = 80;
  var beginButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 35, width, 30)];
  [beginButton setTitle: "Begin"];
  [aView addSubview:beginButton];
  controller.beginButton = beginButton;
  [beginButton setTarget: controller];
  [beginButton setAction: @selector(beginReserving:)];


}

- (void) addDateDisplayingControlsTo: aView
{
  //  [aView setBackgroundColor: [CPColor redColor]];

  var aLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 35, 500, 30)];
  [aView addSubview:aLabel];
  [aLabel setStringValue: "on the morning of 2009-08-10"];
  controller.dateTimeSummary = aLabel;
}


-(void) dateTimeEditingPanel
{
  var panel = [[DateTimeEditingPanel alloc] initAtX: 550 y: 50];
  var control = [[DateTimeEditingControl alloc] init];
  [control setTarget: controller];
  
  controller.dateTimeEditingControl = control;
  [panel setContentView: control];

  panelController = [[PanelController alloc] init];
  panelController.panel = panel;
  controller.dateTimeEditingPanelController = panelController;
}

@end
