@import "DateInterfaceController.j"
@import "Mock.j"

@implementation DateInterfaceControllerTest : OJTestCase
{
  DateInterfaceController controller;
  Mock textField;
  Mock store;
}

- (void)setUp
{
  controller = [[DateInterfaceController alloc] init];
  textField = [[Mock alloc] init];
  store = [[Mock alloc] init];
}


- (void)testPickingDateNotifiesListenersOfEvent
{
  var listener = [[Mock alloc] init];
  [[CPNotificationCenter defaultCenter]
   addObserver: listener
   selector: @selector(dateChosen:)
   name: @"date chosen"
   object: nil];

  [listener shouldReceive: @selector(dateChosen:)];

  [[[DateInterfaceController alloc] init] newDate: nil];


  [self assertTrue: [listener wereExpectationsFulfilled]];
}


- (void)testPickingDateCausesExclusionsToBeRetrievedAndNotified
{
  controller.persistentStore = store;

  listener = [[Mock alloc] init];
  [[CPNotificationCenter defaultCenter]
   addObserver: listener
   selector: @selector(notifyOfExclusions:)
   name: @"exclusions"
   object: nil];


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
