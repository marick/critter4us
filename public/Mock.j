@implementation Expectation : CPObject
{
  SEL selector;
  CPArray args;
  id retval;
}

- (CPString) description
{
  return [CPString stringWithFormat: "expectation: %s %@ => %@", selector, args, retval];
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
  id expectations;
  id actualities;
  id buildingExpectation;
  BOOL printErrors;
  BOOL happiness;
}

-(Mock)init
{
  expectations = [[CPMutableDictionary alloc] init];
  actualities = [[CPArray alloc] init];
  printErrors = YES;
  happiness = YES;
  return self;
}


- (Mock)shouldReceive: (SEL)aSelector
{
  buildingExpectation = [[Expectation alloc] initForSelector: aSelector];
  [expectations setObject: buildingExpectation forKey: aSelector];
  return self;
}

- (Mock)with: (id)args
{
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
  //CPLog([expectations count]);
  //CPLog([actualities count]);
  if ([expectations count] !== [actualities count])
    {
      [self noteFailure: [CPString stringWithFormat: "%d expected invocations, got %d", [expectations count], [actualities count]]];
    }

  for (var i=0; i < [actualities count]; i++)
    {
      var actuality = actualities[i];
      var selector = [actuality selector];
      var expectation = [expectations objectForKey: selector];
      
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
      CPLog(aString,"warn");
    }
}

// Method_Missing implementation

-(CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
  return 1; // Hack - CPMethodSelectors don't exist yet.
}

- (void)forwardInvocation:(CPInvocation)anInvocation
{
  // CPLog([anInvocation selector])
  matchingMethod = [expectations objectForKey: [anInvocation selector]];
  if (matchingMethod)
    {
      [anInvocation setReturnValue: [matchingMethod returnValue]];
      [actualities addObject: anInvocation];
    }
  else
    {
      [super forwardInvocation: anInvocation];
    }
}

// Convenience methods

- (Mock)shouldReceive: (SEL)aSelector andReturn: (id)aValue
{
  return [[self shouldReceive: aSelector] andReturn: aValue];
}


- (Mock)shouldReceive: (SEL)aSelector with: (CPArray)args
{
  if (typeof(args) == "function")
    {
      args = [args];
    }
  if (! [args isKindOfClass: CPArray])
    {
      args = [args];
    }
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

