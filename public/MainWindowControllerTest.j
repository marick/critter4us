@import "MainWindowController.j"
@import "Mock.j"

@implementation MainWindowControllerTest : OJTestCase
{
  MainWindowController controller;
  Mock textField;
  Mock store;
}

- (void)setUp
{
  textField = [[Mock alloc] init];

  controller = [[MainWindowController alloc] init];
  store = [[Mock alloc] init];
  controller.persistentStore = store;

  listener = [[Mock alloc] init];
  [[CPNotificationCenter defaultCenter]
   addObserver: listener
   selector: @selector(notifyOfExclusions:)
   name: @"exclusions"
   object: nil];
}

- (void)testPickingDateCausesExclusionsToBeRetrievedAndNotified
{
  [textField shouldReceive: @selector(stringValue) andReturn: @"some date"];
  [store shouldReceive: @selector(exclusionsForDate:) with: [@"some date"] andReturn: @"some exclusions"];

  var objectChecker = function(notification) { 
    return [notification object] === @"some exclusions";
  }

  [listener shouldReceive: @selector(notifyOfExclusions:) with: objectChecker];

  [controller newDate: textField];

  [self assertTrue: [textField wereExpectationsFulfilled]];
  [self assertTrue: [store wereExpectationsFulfilled]];
  [self assertTrue: [listener wereExpectationsFulfilled]];
}

