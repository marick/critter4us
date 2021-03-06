@import "PrimitivesToModelObjectsConverter.j"

@implementation JsonToModelObjectsConverter : CritterObject
{
}

+ (JsonToModelObjectsConverter) converter
{
  return [[self alloc] init];
}

+ (CPDictionary) convert: json
{
  return [[[JsonToModelObjectsConverter alloc] init] convert: json];
}

- (CPDictionary) convert: json
{
  [self log: "This JSON has been received: " + json];
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

