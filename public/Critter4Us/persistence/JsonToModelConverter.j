@import "FromNetworkConverter.j"

@implementation JsonToModelConverter : CritterObject
{
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

  return [FromNetworkConverter convert: jsHash];
}

@end

