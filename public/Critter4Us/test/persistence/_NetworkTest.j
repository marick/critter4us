@import <Critter4Us/persistence/NetworkConnection.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _NetworkTest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [[NetworkConnection alloc] init];

  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutCreates: ['connectionMaker']];

  get_request_containing_route = function(route) {
    return function(request) {
      [self assert: "GET" equals: [request HTTPMethod]];
      [self assert: route equals: [request URL]];
      return YES;
    }
  }

  post_request_containing = function(route, content) {
    return function(request) {
      [self assert: "POST" equals: [request HTTPMethod]];
      [self assert: content equals: [request HTTPBody]];
      [self assert: route equals: [request URL]];
      return YES;
    }
  }
}

- (void) test_sending_a_GET
{
  [scenario
    during: function() { 
      [sut get: "some route" continuingWith: "a continuation"];
    }
  behold: function() { 
      [sut.connectionMaker shouldReceive: @selector(connectionWithRequest:delegate:)
                            with: [get_request_containing_route("some route"),
                                   "a continuation"]];
      [self listenersShouldReceiveNotification: BusyNews];
    }];
}

- (void) test_sending_a_POST
{
  [scenario
    during: function() { 
      [sut postContent: "some content" toRoute: "some route"
        continuingWith: "a continuation"];
    }
  behold: function() { 
      [sut.connectionMaker shouldReceive: @selector(connectionWithRequest:delegate:)
                                    with: [post_request_containing("some route", "some content"),
                                   "a continuation"]];
      [self listenersShouldReceiveNotification: BusyNews];
    }];
}




@end
