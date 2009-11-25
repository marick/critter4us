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
  CPTextField dateField;
  CPRadio afternoonButton; 

  CPButton dateTimeButton;
  PanelController panelController;
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

  var instructionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 400, 30)];
  [instructionLabel setStringValue: "Fill in the information, then click the button."];
  [pageView addSubview: instructionLabel];


  var x = 10;
  var width = 45
  var courseLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [courseLabel setStringValue: "Course: "];
  [pageView addSubview:courseLabel];
  x += width;

  width = 100;
  courseField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [courseField setEditable:YES];
  [courseField setBezeled:YES];
  [pageView addSubview:courseField];
  controller.courseField = courseField;
  x+= width;

  x += 10;
  width = 90;
  var instructorLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [instructorLabel setStringValue: "Instructor NetID: "];
  [pageView addSubview:instructorLabel];
  x += width;

  width = 100;
  instructorField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [instructorField setEditable:YES];
  [instructorField setBezeled:YES];
  [pageView addSubview:instructorField];
  controller.instructorField = instructorField;
  x += width;

  var dateGatheringView = [[CPView alloc] initWithFrame:CGRectMake(x, 40, 330, 100)];
  [self addDateGatheringControlsTo: dateGatheringView];
  [pageView addSubview:dateGatheringView];
  [dateGatheringView setHidden: NO];
  controller.dateGatheringView = dateGatheringView;

  var dateDisplayingView = [[CPView alloc] initWithFrame:CGRectMake(x, 40, 400, 100)];
  [self addDateDisplayingControlsTo: dateDisplayingView];
  [pageView addSubview:dateDisplayingView];
  [dateDisplayingView setHidden: YES];
  controller.dateDisplayingView = dateDisplayingView;

  x += 345;
  var placeForLink = x;
  width = 160;

  var reserveButton = [[CPButton alloc] initWithFrame:CGRectMake(320, 410, width, 30)];
  [reserveButton setTitle: "Finish this Reservation"];
  [reserveButton setHidden: YES];
  [pageView addSubview:reserveButton];
  controller.reserveButton = reserveButton;
  [reserveButton setTarget: controller];
  [reserveButton setAction: @selector(makeReservation:)];

  width = 80;
  x = [pageView bounds].size.width - width - 35
  var restartButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [restartButton setTitle: "Start Over"];
  [restartButton setHidden: YES];
  [pageView addSubview:restartButton];
  controller.restartButton = restartButton;
  [restartButton setTarget: controller];
  [restartButton setAction: @selector(abandonReservation:)];

  var resultsView = [[CPView alloc] initWithFrame: CGRectMake(placeForLink,60,500,200)];
  [resultsView setHidden: YES];
  [pageView addSubview: resultsView];
  controller.previousResultsView = resultsView;

  var webView = [[CPWebView alloc] initWithFrame: CGRectMake(0,0,500,300)];
  [resultsView addSubview: webView];
  controller.linkToPreviousResults = webView;

  var copyButton = [[CPButton alloc] initWithFrame: CGRectMake(50, 40, 200, 30)];
  [copyButton setTitle: "Copy this Reservation"];
  [copyButton setTarget: controller];
  [copyButton setAction: @selector(copyPreviousReservation:)];
  [resultsView addSubview: copyButton];
  controller.copyButton = copyButton;

  // Temporary for testing
  [instructorField setStringValue: "morin"];
  [courseField setStringValue: "VM333"];
  [dateField setStringValue: "2009-09-23"];

  // TODO: do this with notifications.
  [courseField setNextKeyView: dateField];
  [dateField setNextKeyView: afternoonButton];

  // Doesn't work.
  //  [theWindow setDefaultButton: goButton];
  //  [theWindow enableKeyEquivalentForDefaultButton];
}

  
    
- (void) addDateGatheringControlsTo: aView
{
  //  [aView setBackgroundColor: [CPColor redColor]];
  
  x = 10;
  width = 20;
  var onLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 35, width, 30)];
  [onLabel setStringValue: "on: "];
  [aView addSubview:onLabel];
  x += width;

  width = 100;
  dateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 30, width, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-"];
  [aView addSubview:dateField];
  controller.dateField = dateField;
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

  var aLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 35, 200, 30)];
  [aView addSubview:aLabel];
  [aLabel setStringValue: "on the morning of 2009-08-10"];
  controller.dateTimeSummary = aLabel;

  dateTimeButton = [[CPButton alloc] initWithFrame:CGRectMake(200, 30, 160, 30)];
  [dateTimeButton setTitle: "Change Date or Time"];
  [aView addSubview:dateTimeButton];
  [dateTimeButton setTarget: controller];
  [dateTimeButton setAction: @selector(startDestructivelyEditingDateTime:)];
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
