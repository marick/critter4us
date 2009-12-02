@import "Future.j"
@import "../model/Animal.j"

@implementation AnimalInServiceListFuture : Future
{
  int count;
}

- (CPDictionary) convert: json
{
  if (! json)
  {
    alert("AnimalInServiceList: No JSON string received after posting. Please report this.");
    return;
  }

  var jsHash =  [json objectFromJSON];
  if (! jsHash)
  {
    alert("AnimalInServiceList: No hash was obtained from JSON string " + json + "\n Please report this.");
    return;
  }
  
  var retval = [CPDictionary dictionary];
  [retval setValue: [self makeNamedObjects: jsHash['unused animals']]
            forKey: 'unused animals'];

  return retval;
}


// Private

- (CPArray) makeNamedObjects: array
{
  var retval = [];
  for(i=0; i < [array count]; i++)
  {
    [retval addObject: [[NamedObject alloc] initWithName: array[i]]];
  }
  return retval;
}


@end
