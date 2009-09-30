@import "../util/AwakeningObject.j"
@import "../controller/PanelController.j"

@implementation Advisor : CritterObject
{
  BOOL skipStandardConfiguration;
}

- (id) init
{
  self = [super init];
  [self setUpNotifications];
  return self;
}

- (void) setUpNotifications
{
  [self notificationNamed: AdviceAboutAnimalsDroppedNews
                    calls: @selector(spawnAdvice:)];
}

- (void) spawnAdvice: aNotification
{
  [self makeStandardConfiguration];
  [self specialize: [aNotification object]];
}

- (void) makeStandardConfiguration
{
  if (skipStandardConfiguration) return;

  var horizontalSpaceForText = 400;
  var verticalSpaceForText = 120;
  var advisoryColor = [CPColor colorWithRed: 0.99 green: 0.98 blue: 0.70 alpha: 1.0];

  textField = [[CPTextField alloc] initWithFrame:
                                     CGRectMake(0, 0, horizontalSpaceForText, 1200)];
  [textField setBackgroundColor: advisoryColor];
  [textField setLineBreakMode: CPLineBreakByWordWrapping];

  var scroller = [[CPScrollView alloc] initWithFrame:
                          CGRectMake(0, 0, horizontalSpaceForText + [CPScroller scrollerWidth], verticalSpaceForText)];
  [scroller setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [scroller setAutohidesScrollers:NO];
  [scroller setDocumentView:textField];

  var rect = CGRectMake(600, 60, [scroller bounds].size.width, [scroller bounds].size.height);
  panel = [[CPPanel alloc] initWithContentRect: rect
                                     styleMask: CPTitledWindowMask |
                                                CPClosableWindowMask |
                                                CPMiniaturizableWindowMask |
                                                CPResizableWindowMask];

  [panel setFloatingPanel:YES];
  [panel setTitle:@"Advisory"];
  [panel setContentView: scroller];

  controller = [[PanelController alloc] initWithPanel: panel];
}

- (void) specialize: message
{
  [textField setStringValue: message];
  [panel setDelegate: controller];
  [controller appear];
  [NotificationCenter postNotificationName: NewPanelOnPageNews
                                    object: controller];
}

@end
