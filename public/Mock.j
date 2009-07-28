
@implementation Mock : CPObject
{
  id expectations;
  id actualities;
  id buildingExpectation;
}

-(Mock)init
{
  expectations = [[CPMutableDictionary alloc] init];
  actualities = [[CPArray alloc] init];
  return self;
}


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

- (Mock)shouldReceive: (SEL)aSelector andReturn: (id)aValue
{
  return [[self shouldReceive: aSelector] andReturn: aValue];
}


- (Mock)shouldReceive: (SEL)aSelector
{
  invocation = [CPInvocation invocationWithMethodSignature: 'ignored'];
  [invocation setSelector: aSelector];
  [expectations setObject: invocation 
           forKey: aSelector];
  buildingExpectation = aSelector;

  return self;
}

- (Mock)andReturn: (id)aValue
{
  [[expectations objectForKey: buildingExpectation] setReturnValue: aValue];
  return self;
}

- (BOOL)wereExpectationsFulfilled
{
  // CPLog([expectations count]);
  // CPLog([actualities count]);
  return [expectations count] === [actualities count];
}
@end

