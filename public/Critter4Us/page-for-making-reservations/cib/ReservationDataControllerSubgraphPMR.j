@import "../../cib/Subgraph.j"
@import "../ReservationDataControllerPMR.j"
@import "../../view/TimesliceControl.j"
@import "../../view/TimesliceChangingPopup.j"
@import "../../view/TimesliceChangingControl.j"
@import "../../controller/PanelController.j"
@import "../../util/Constants.j"
@import "../../util/TimesliceSummarizer.j"


@implementation ReservationDataControllerSubgraphPMR : Subgraph
{
  ReservationDataControllerPMR controller;

  CPTextField instructorField;
  CPTextField courseField;
  TimesliceControl timesliceControl;
  CPRadio afternoonButton; 

  CPButton timesliceButton;
  PanelController panelController;
  ReservationDataControllerPMR controller;
  // There are others but no need to make them instance vars.
}


- (id) initOnPage: pageView
{
  self = [super init];
  
  controller = [self custom: [[ReservationDataControllerPMR alloc] init]];
  [self drawControlsOnPage: pageView];
  [self timesliceChangingPopup];
  [self setKeyViewLoop];
  return self;
}

- (void) connectOutlets
{
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

  var dateGatheringView = [[CPView alloc] initWithFrame:CGRectMake(x, y-30, 400, 100)];
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

  var timesliceSummary = [[TimesliceSummary alloc] initWithFrame:CGRectMake(x, y-30, 450, 100)];
  [pageView addSubview:timesliceSummary];
  controller.timesliceSummary = timesliceSummary;

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
  timesliceButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 35, 160, 30)];
  [timesliceButton setTitle: "Change Date or Time"];
  [timesliceButton setHidden: NO];
  [aView addSubview:timesliceButton];
  [timesliceButton setTarget: controller];
  [timesliceButton setAction: @selector(startDestructivelyEditingTimeslice:)];
}
    
- (void) addDateGatheringControlsTo: aView
{
  //  [aView setBackgroundColor: [CPColor redColor]];
  

  x = 10;
  timesliceControl = [[TimesliceControl alloc] initAtX: x y: 0]
  [aView addSubview: timesliceControl];
  controller.timesliceControl = timesliceControl;
    
  x += [timesliceControl bounds].size.width - 30
  width = 80;
  var beginButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 35, width, 30)];
  [beginButton setTitle: "Begin"];
  [aView addSubview:beginButton];
  controller.beginButton = beginButton;
  [beginButton setTarget: controller];
  [beginButton setAction: @selector(beginReserving:)];
}

-(void) timesliceChangingPopup
{
  var panel = [[TimesliceChangingPopup alloc] initAtX: 550 y: 50];
  var control = [[TimesliceChangingControl alloc] init];
  [control setTarget: controller];
  
  controller.timesliceChangingControl = control;
  [panel setContentView: control];

  panelController = [[PanelController alloc] init];
  panelController.panel = panel;
  controller.timesliceChangingPopupController = panelController;
}

- (void) setKeyViewLoop
{
  // TODO: Doesn't work in capp 0.7
  //  [theWindow setDefaultButton: goButton];
  //  [theWindow enableKeyEquivalentForDefaultButton];

  // TODO: do this with notifications.
  [courseField setNextKeyView: instructorField];
  [instructorField setNextKeyView: timesliceControl.dateControl.firstDateField];
  [timesliceControl.dateControl.firstDateField setNextKeyView: timesliceControl.timeControl.morningButton];
}

@end
