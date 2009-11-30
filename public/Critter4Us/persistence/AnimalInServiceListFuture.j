@import "Future.j"
@import "../model/Animal.j"

@implementation AnimalInServiceListFuture : Future

- (CPDictionary) convert: json
{
  if (! json)
    alert("No JSON string received after posting. Please report this.   \nOriginal: " + json);
  var jsHash =  [json objectFromJSON];
  if (! jsHash)
    alert("No hash was obtained from JSON string " + json + "\n Please report this.");
  
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
