@implementation Expectation : CPObject
{
  SEL selector;
  CPArray args;
  id retval;
}

- (CPString) description
{
  return [CPString stringWithFormat: "expectation: %s %@ => %@", selector, [args description], retval];
}

- (id) returnValue
{
  return retval;
}

- (Expectation) initForSelector: (SEL)aSelector
{
  selector = aSelector;
  return self;
}


@end





@implementation Mock : CPObject
{
  id expectationDictionary;
  id actualities;
  id buildingExpectation;
  BOOL printErrors;
  BOOL happiness;
  CPString name;
  BOOL failOnUnexpectedSelector;
  id storedValues;
}

-(Mock)init
{
  expectationDictionary = [[CPMutableDictionary alloc] init];
  actualities = [[CPArray alloc] init];
  printErrors = YES;
  happiness = YES;
  failOnUnexpectedSelector = YES;
  storedValues = [CPMutableDictionary dictionary];
  return self;
}

-(Mock)initWithName: (CPString)aString
{
  [self init];
  name = aString;
  return self;
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
  [expectationDictionary setObject: buildingExpectation forKey: aSelector];
  return self;
}

- (Mock)with: (id)args
{
  if (typeof(args) == "function")
    {
      args = [args];
    }
  if (! [args isKindOfClass: CPArray])
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
  if ([expectationDictionary count] !== [actualities count])
    {
      [self noteFailure: [CPString stringWithFormat: "%d expected invocations, got %d", [expectationDictionary count], [actualities count]]];
    }

  for (var i=0; i < [actualities count]; i++)
    {
      var actuality = actualities[i];
      var selector = [actuality selector];
      var expectation = [expectationDictionary objectForKey: selector];
      if (expectation == null)
	{
	  [self noteFailure: [CPString stringWithFormat: "No expectation for %@", selector]];
	}
      else
	{
	  [self compareExpectedArguments: expectation toActual: actuality];
	}
    }
  return happiness;
}


- (void) compareExpectedArguments: (Expectation)expectation toActual: (CPInvocation)actuality
{
  if (expectation.args == null) return;

  for(var i=0; i < [expectation.args count]; i++)
    {
      var expected = expectation.args[i];
      var actual = [actuality argumentAtIndex: i+2];
      var goodArg = NO;
      if (typeof(expected) == "function") 
	{
	  goodArg = expected(actual);
	}
      else if (expected.isa != undefined) // There is probably a better test.
	{
	  goodArg = [expected isEqual: actual];
	}
      else  
	{
	  goodArg = (expected === actual);
	}

      if (! goodArg)
	{
	  [self noteFailure: [CPString stringWithFormat: "For %@, expected arg %d to be %@, was %@.", expectation.selector, i, expected, actual]];
	}
    }
}


-(void)noteFailure: (CPString)aString
{
  happiness = NO;
  if (printErrors)
    {
      CPLog([CPString stringWithFormat: "%s: %s", [self description], aString],
            "warn");
    }
}

// Method_Missing implementation

-(CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
  return 1; // Hack - CPMethodSelectors don't exist yet.
}

- (void)forwardInvocation:(CPInvocation)anInvocation
{
  var selector = [anInvocation selector];
  var matchingMethod = [expectationDictionary objectForKey: selector];
  if (matchingMethod)
    {
      [anInvocation setReturnValue: [matchingMethod returnValue]];
      [actualities addObject: anInvocation];
    }
  else if ([self isSetter: selector])
    {
      var variable = [self setterToVariable: selector];
      var value = [anInvocation argumentAtIndex: 2];
      [storedValues setValue: value forKey: variable];
    }
  else if ([self isExpectedGetter: selector])
    {
      var variable = CPStringFromSelector(selector);
      var retval = [storedValues objectForKey: variable];
      [anInvocation setReturnValue: retval];
    }
  else if (failOnUnexpectedSelector)
    {
      [super forwardInvocation: anInvocation];
    }
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
  var len = [stringVersion length];

  var prefix = [stringVersion substringWithRange:CPMakeRange(0,3)];
  var suffix = [stringVersion substringWithRange:CPMakeRange(len-1, 1)];
  return  [prefix isEqual: "set"] && [suffix isEqual: ':'];
}

-(BOOL) isExpectedGetter: selector
{
  var stringVersion = CPStringFromSelector(selector);
  return [storedValues objectForKey: stringVersion];
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
  printErrors = NO;
}



@end

