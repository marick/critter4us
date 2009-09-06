@import "Subgraph.j"
@import "../ReservationDataControllerPMR.j"


@implementation ReservationDataControllerSubgraph : Subgraph
{
  ReservationDataControllerPMR controller;
  // Subviews not listed here because no external nodes will ever connect to them.
}


- (id) initOnPage: pageView
{
  self = [super init];
  
  controller = [self custom: [[ReservationDataControllerPMR alloc] init]];
  [self drawControlsOnPage: pageView];
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
  var courseField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [courseField setEditable:YES];
  [courseField setBezeled:YES];
  [pageView addSubview:courseField];
  x+= width;

  x += 10;
  width = 90;
  var instructorLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [instructorLabel setStringValue: "Instructor NetID: "];
  [pageView addSubview:instructorLabel];
  x += width;

  width = 100;
  var instructorField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [instructorField setEditable:YES];
  [instructorField setBezeled:YES];
  [pageView addSubview:instructorField];
  x += width;

  x += 10;
  width = 20;
  var onLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [onLabel setStringValue: "on: "];
  [pageView addSubview:onLabel];
  x += width;

  width = 100;
  var dateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-"];
  [pageView addSubview:dateField];
  x += width;

  x += 10;
  width = 90
  var morningButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 67, width, 20)];
  [morningButton setState:CPOnState];
  [morningButton setTitle:"morning"];
  
  var afternoonButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 87, width, 20) radioGroup:[morningButton radioGroup]];
  [afternoonButton setTitle:"afternoon"];

  [pageView addSubview: morningButton];
  [pageView addSubview: afternoonButton];
  x += width;
    
  x += 15;
  width = 80;
  var beginButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [beginButton setTitle: "Begin"];
  [pageView addSubview:beginButton];
  [beginButton setTarget: controller];
  [beginButton setAction: @selector(commitToParticularCourseSession:)];
  x += width;


  x += 15;
  var placeForLink = x;
  width = 80;
  var reserveButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [reserveButton setTitle: "Reserve"];
  //  [reserveButton setHidden: YES];  TODO: turn on
  [pageView addSubview:reserveButton];
  [reserveButton setTarget: controller];
  [reserveButton setAction: @selector(makeReservation:)];
  x += width;

  x += 15;
  width = 180;
  var restartButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [restartButton setTitle: "Restart (doesn't work yet)"];
  //  [restartButton setHidden: YES];  TODO turn on
  [pageView addSubview:restartButton];
  [restartButton setTarget: controller];
  [restartButton setAction: @selector(abandonReservation:)];


  var webView = [[CPWebView alloc] initWithFrame: CGRectMake(placeForLink,60,500,100)];
  //  [webView setHidden: YES]; TODO turn on
  [pageView addSubview: webView];

  controller.linkToPreviousResults = webView;
  controller.courseField = courseField;
  controller.instructorField = instructorField;
  controller.dateField = dateField;
  controller.morningButton = morningButton;
  controller.beginButton = beginButton;
  controller.reserveButton = reserveButton;
  controller.restartButton = restartButton;

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
  [customObjectsLoaded addObject:controller];
}


@end
