@import <Critter4Us/test/testutil/MockArgumentDescriptions.j>

@implementation Expectation : CPObject
{
  SEL selector;
  CPArray args;
  id retval;
  CPInteger expectedInvocationCount;
  CPInteger actualInvocationCount;
}

- (Expectation) initForSelector: (SEL)aSelector
{
  selector = aSelector;
  expectedInvocationCount = 1;
  actualInvocationCount = 0;
  return self;
}

- (CPString) description
{
  return [CPString stringWithFormat: "expectation: [%s %s => %s]", selector,
                                                                 [args description],
                                                                 [retval description]];
}

- (id) returnValue
{
  return retval;
}

@end


@implementation ExpectationMatcher : CPObject
{
  BOOL printErrors;
  CPMutableArray expectations;
  Expectation matchedExpectation;
  Mock mock;
}

- (id) initForMock: aMock
{
  self = [super init];
  expectations = [CPMutableArray array];
  matchedExpectation = nil;
  mock = aMock;
  printErrors = YES;
  return self;
}

- (void) add: expectation
{
  [expectations addObject: expectation];
}

- (id) returnValue
{
  return [matchedExpectation returnValue];
}


- (BOOL) hasMatchFor: invocation 
{
  matchedExpectation = nil;
  for (var i=0; i < [expectations count]; i++)
  {
    var expectation = expectations[i];
    if ([self expectation: expectation matches: invocation])
    {
      matchedExpectation = expectation;
      matchedExpectation.actualInvocationCount++;
      break;
    }
  }
  if (matchedExpectation) return YES;
  return NO;
}


- (BOOL) expectation: expectation matches: invocation
{
  if (![expectation.selector isEqual: [invocation selector]])
    return NO;

  return [self doExpectedArguments: expectation match: invocation];
}


- (BOOL) doExpectedArguments: (Expectation)expectation match: (CPInvocation)invocation
{
  if (expectation.args == null) return YES;

  for(var i=0; i < [expectation.args count]; i++)
    {
      var expected = expectation.args[i];
      var actual = [invocation argumentAtIndex: i+2];
      var goodArg = NO;
      if (typeof(expected) == "function") 
	{
	  goodArg = expected(actual);
	}
      else if (expected === nil)
	{
	  goodArg = (actual === nil);
	}
      else if (expected.isa != undefined) // There is probably a better test.
	{
	  goodArg = [expected isEqual: actual];
	}
      else  
	{
	  goodArg = (expected === actual);
	}

      if (! goodArg) return NO;
    }
  return YES;
}

- (BOOL) areCountsCorrect
{
  var retval = YES
  for (var i=0; i < [expectations count]; i++)
  {
    var expectation = expectations[i];
    if (expectation.expectedInvocationCount != expectation.actualInvocationCount)
    {
      [self noteFailure: [CPString stringWithFormat: "%@ expected %d invocations, got %d", 
                                   [expectation description],
                                   expectation.expectedInvocationCount,
                                   expectation.actualInvocationCount]];
      retval = NO;
    }
  }
  return retval;
}


-(void)noteFailure: (CPString)aString
{
  if (printErrors)
    {
      CPLog([CPString stringWithFormat: "%s: %s", [mock description], aString],
            "warn");
    }
}

 - (void) noteFailure: aString forExpectation: expectation
 {
   [self noteFailure: [CPString stringWithFormat: "%s: %s", [expectation description], aString]];
 }


@end





@implementation Mock : CPObject
{
  id expectationMatcher;
  id buildingExpectation;
  CPString name;
  BOOL failOnUnexpectedSelector;
  id storedValues;
  BOOL trace;
  BOOL happiness;
}

-(Mock)init
{
  [self clear]
  failOnUnexpectedSelector = YES;
  trace = NO;
  return self;
}

-(Mock)initWithName: (CPString)aString
{
  [self init];
  name = aString;
  return self;
}

-(void) clear
{
  expectationMatcher = [[ExpectationMatcher alloc] initForMock: self];
  storedValues = [CPMutableDictionary dictionary];
  happiness = YES;
}

- (CPString) description
{
  if (name)
    {
      return [CPString stringWithFormat: "Mock %s", name];
    }
  else
    {
      return "Mock";
    }
}


- (Mock)shouldReceive: (SEL)aSelector
{
  buildingExpectation = [[Expectation alloc] initForSelector: aSelector];
  [expectationMatcher add: buildingExpectation];
  return self;
}

- (Mock)with: (id)args
{
  if (typeof(args) == "function")
  {
    args = [args];
  }
  else if (args.isa == undefined)
  {
    args = [args];
  }
  else if (! [args isKindOfClass: CPArray])
  {
    args = [args];
  }

  buildingExpectation.args = args;
  return self;	
}

- (Mock)andReturn: (id)aValue
{
  buildingExpectation.retval = aValue;
  return self;
}

- (BOOL)wereExpectationsFulfilled
{
  return happiness && [expectationMatcher areCountsCorrect];
}


// Method_Missing implementation

-(CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
  return 1; // Hack - CPMethodSelectors don't exist yet.
}

- (void)forwardInvocation:(CPInvocation)anInvocation
{
  if (trace)
  {
    CPLog('Mock ' + name + ' called: ' + [anInvocation selector] + [[self argumentsOf: invocation] description]);
  }
  var selector = [anInvocation selector];
  //  CPLog(selector);
  if ([expectationMatcher hasMatchFor: anInvocation])
    {
      // CPLog("a matching method will return " + [expectationMatcher returnValue]);
      [anInvocation setReturnValue: [expectationMatcher returnValue]];
    }
  else if ([self isSetter: selector])
    {
      var variable = [self setterToVariable: selector];
      var value = [anInvocation argumentAtIndex: 2];
      // CPLog("Mock storing " + value + " for " + variable);
      [storedValues setValue: value forKey: variable];
    }
  else if ([self isExpectedGetter: selector])
    {
      var variable = CPStringFromSelector(selector);
      var retval = [storedValues objectForKey: variable];
      // CPLog("Mock returning " + retval + " for " + variable);
      [anInvocation setReturnValue: retval];
    }
  else if (failOnUnexpectedSelector)
    {
      happiness = NO;
      [super forwardInvocation: anInvocation];
    }
}

-(CPString) argumentsOf: invocation
{
  var args = [invocation._arguments copy]; // Right now, there aren't method signatures in cappuccino, so cheat.
  [args removeObjectAtIndex: 0]; // target
  [args removeObjectAtIndex: 0]; // selector
  return args;
}

-(CPString) setterToVariable: selector
{
  var stringVersion = CPStringFromSelector(selector);
  var len = [stringVersion length];

  var firstChar = [stringVersion substringWithRange: CPMakeRange(3, 1)];
  var rest = [stringVersion substringWithRange: CPMakeRange(4, len-5)];
  return [firstChar lowercaseString] + rest;
}

-(BOOL) isSetter: selector
{
  var stringVersion = CPStringFromSelector(selector);
  // CPLog([self description] + " checking if " + stringVersion + " is a setter");
  var len = [stringVersion length];

  var prefix = [stringVersion substringWithRange:CPMakeRange(0,3)];
  var suffix = [stringVersion substringWithRange:CPMakeRange(len-1, 1)];
  return  [prefix isEqual: "set"] && [suffix isEqual: ':'];
}

-(BOOL) isExpectedGetter: selector
{
  // Doesn't handle "isFoo" yet.
  var stringVersion = CPStringFromSelector(selector);
  // CPLog("is " + stringVersion + "a getter in " );
  // CPLog([storedValues description]);
  if ([storedValues objectForKey: stringVersion] != nil) return YES;

  return NO;
  return [storedValues objectForKey: stringVersion] != nil;
}


// Convenience methods

- (Mock)shouldReceive: (SEL)aSelector andReturn: (id)aValue
{
  return [[self shouldReceive: aSelector] andReturn: aValue];
}


- (Mock)shouldReceive: (SEL)aSelector with: (CPArray)args
{
  return [[self shouldReceive: aSelector] with: args];
}


- (Mock)shouldReceive: (SEL)aSelector with: (id)args andReturn: (id)aValue
{
  return [[[self shouldReceive: aSelector] with: args] andReturn: aValue];
}



// Test support
-(void)silenceErrors
{
  expectationMatcher.printErrors = NO;
}



@end

