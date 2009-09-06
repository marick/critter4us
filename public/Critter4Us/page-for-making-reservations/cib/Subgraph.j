@implementation Subgraph : CPObject
{
  CPArray customObjectsLoaded;
}

- (id) init
{
  customObjectsLoaded = [[CPArray alloc] init];
  return self;
}


- (id) custom: anObject
{
  [customObjectsLoaded addObject:anObject];
  return anObject;
}

- (void) awakeFromCib
{
  for(i=0; i < [customObjectsLoaded count]; i++)
    {
      var obj = [customObjectsLoaded objectAtIndex: i];
      if ([obj respondsToSelector: @selector(awakeFromCib)])
	{
	  [obj awakeFromCib];
	}
    }
}

@end
