@import "Mock.j"

@implementation MockTest : OJTestCase
{
  (Mock) mock;
}

- (void)setUp
{
  mock = [[Mock alloc] init];
  [mock silenceErrors];
}

- (void)testExpectationsCanBeFulfilled
{
  [mock shouldReceive: @selector(foo)];
  [mock foo];
  
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testExpectationsCanBeUnfulfilled
{
  [mock shouldReceive: @selector(foo)];
  
  [self assertFalse: [mock wereExpectationsFulfilled]];
}

- (void)testExpectationsCanSpecifyReturnValue
{
  [mock shouldReceive: @selector(foo) andReturn: 5];
  [self assert: 5 equals: [mock foo]];
  
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testExpectationsCanIgnoreArguments
{
  [mock shouldReceive: @selector(foo:)];
  [mock foo: 5];
  
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testExpectationsCanCheckArgumentsAndFail
{
  [mock shouldReceive: @selector(foo:) with: [5]];
  [mock foo: 6];
  
  [self assertFalse: [mock wereExpectationsFulfilled]];
}

- (void)testExpectationsCanCheckArgumentsAndPass
{
  [mock shouldReceive: @selector(foo:) with: [5]];
  [mock foo: 5];
  
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testSingleArgumentsDoNotHaveToBeInArray
{
  [mock shouldReceive: @selector(foo:) with: 5];
  [mock foo: 5];
  
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testExpectationsCanReceiveAFunctionToExecute
{
  [mock shouldReceive: @selector(foo:) with: [function(x) { return x == 100 }]];
  [mock foo: 100];

  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testSingleFunctionArgumentsDoNotHaveToBeInArray
{
  var f = function(a) { return a == 5 }
  [mock shouldReceive: @selector(foo:) with: f];
  [mock foo: 5];
  
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testUnnamedMocksDescriptionsAreClassNames
{
  [self assert: "Mock" equals: [[[Mock alloc] init] description]];
}

- (void)testNamedMocksHaveNamedDescription
{
  [self assert: "Mock fred"
        equals: [[[Mock alloc] initWithName: "fred"] description]];
}

- (void)testMocksCanBeToldToSwallowUnexpectedMessages
{
  mock.failOnUnexpectedSelector = NO;
  [mock unexpected];
  [self assertTrue: [mock wereExpectationsFulfilled]];
}	

@end
