@import <Critter4Us/test/testutil/Mock.j>

@implementation _MockTest : OJTestCase
{
  Mock mock;
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
  [mock shouldReceive: @selector(foo) andReturn: [5, "hi"]];
  [self assert: [5, "hi"] equals: [mock foo]];
  
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
  mock.failOnUnexpectedSelector = NO
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

- (void)testNilCanBeAnExpectedArgument
{
  [mock shouldReceive: @selector(foo:bar:) with: [1, nil]];
  [mock foo: 1 bar: nil];
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testSingleArgumentsDoNotHaveToBeInArray
{
  [mock shouldReceive: @selector(foo:) with: "5"];
  [mock foo: "5"];
  
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testExpectationsCanReceiveAFunctionToExecute
{
  var hashTester = function(x) { return x['a'] === 'b' };
  var jsHash = {'a':'b'};
  [mock shouldReceive: @selector(foo:) with: hashTester];
  [mock foo: jsHash];

  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void)testSingleFunctionArgumentsDoNotHaveToBeInArray
{
  var f = function(a) { return a == 5 }
  [mock shouldReceive: @selector(foo:) with: f];
  [mock foo: 5];
  
  [self assertTrue: [mock wereExpectationsFulfilled]];
}


- (void) test_that_the_same_selector_can_be_named_twice
{
  [mock shouldReceive: @selector(foo:) with: [['array']]];
  [mock shouldReceive: @selector(foo:) with: "string"];
  [mock foo: "string"];
  [mock foo: ['array']];
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

- (void) test_that_calling_just_one_selector_does_not_mean_success
{
  [mock shouldReceive: @selector(foo:) with: 1];
  [mock shouldReceive: @selector(foo:) with: 2];
  [mock foo: 1];
  [self assertFalse: [mock wereExpectationsFulfilled]];
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


-(void)testMocksCanConvertSettersToGetterNames
{
  mock = [[Mock alloc] initWithName: "fred"];
  [self assert: "downcase" equals: [mock setterToVariable: @selector(setDowncase:)]];
}

// This is not foolproof: consider [foo set:Based:];
-(void)testMocksCanRecognizeSetters
{
  mock = [[Mock alloc] initWithName: "fred"];
  [self assertTrue: [mock isSetter: @selector(setDowncase:)]];
  [self assertFalse: [mock isSetter: @selector(seDowncase:)]];
  [self assertFalse: [mock isSetter: @selector(setDowncase)]];
}

-(void)testMocksCanStoreSetterValues
{
  mock = [[Mock alloc] initWithName: "fred"];
  [mock setThatThing: 3];
  [self assert: 3 equals: [mock thatThing]];
}

-(void)testSettersAndGettersAreNotRecordedAsExpectationFailures
{
  mock = [[Mock alloc] initWithName: "fred"];
  [mock setThatThing: 3];
  [self assert: 3 equals: [mock thatThing]];
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

-(void)test_setters_and_getters_and_expectations_can_be_combined
{
  mock = [[Mock alloc] initWithName: "fred"];
  [mock shouldReceive: @selector(foo:) with: 1];
  [mock foo: 1];
  [mock setThatThing: 3];
  [self assert: 3 equals: [mock thatThing]];
  [self assertTrue: [mock wereExpectationsFulfilled]];
}

@end
