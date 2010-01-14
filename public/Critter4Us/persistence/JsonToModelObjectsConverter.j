@import "PrimitivesToModelObjectsConverter.j"

@implementation JsonToModelObjectsConverter : CritterObject
{
}

+ (CPDictionary) convert: json
{
  return [[[JsonToModelObjectsConverter alloc] init] convert: json];
}

- (CPDictionary) convert: json
{
  if (! json)
  {
    alert("No JSON string received from server. Please report this.");
    return;
  }

  var jsHash =  [json objectFromJSON];
  if (! jsHash)
  {
    alert("No hash was obtained from JSON string " + json + "\n Please report this.");
    return;
  }

  return [PrimitivesToModelObjectsConverter convert: jsHash];
}

@end

