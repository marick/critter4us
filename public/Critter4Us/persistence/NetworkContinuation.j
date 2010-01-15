@import <Foundation/Foundation.j>
@import "../util/CritterObject.j"
@import "../util/Constants.j"

@implementation NullConverter : CPObject

- (id) convert: data
{
  return data;
}

@end

@implementation NetworkContinuation : CritterObject
{
  CPString result;
  CPString notificationName;
  id converter;
}

+ (NetworkContinuation) continuationNotifying: notificationName afterConvertingWith: converter
{
  return [[NetworkContinuation alloc] initWithNotificationName: notificationName
                                        converter: converter];
}

+ (NetworkContinuation) continuationNotifying: notificationName
{
  return [[NetworkContinuation alloc] initWithNotificationName: notificationName
                                        converter: [[NullConverter alloc] init]];
}

- (id) initWithNotificationName: aNotificationName
                      converter: aConverter
{
  self = [super init];
  notificationName = aNotificationName;
  converter = aConverter;
  result = [CPString string];
  return self;
}

- (CPString) notificationName
{
  return notificationName;
}

/////////

-(void)connection:(CPURLConnection)methodConnection didFailWithError:(id)error
{
  alert("Fail with error");
}

-(void)connection:(CPURLConnection)methodConnection didReceiveResponse:(CPHTTPURLResponse)response
{
}

-(void)connection:(CPURLConnection)methodConnection didReceiveData:(CPString)data
{
  [self log: "connection %@ received %s",
        [methodConnection hash], [self visible: data]];
  result += data;
}

-(void)connectionDidFinishLoading:(CPURLConnection)methodConnection
{
  [self log: "connection %@ finished", [methodConnection hash]];
  if (result == "") 
  {
    [self log: "empty result suggests this is a spurious connection from Firefox"];
    return;
  }
  [NotificationCenter postNotificationName: [self notificationName]
                                    object: [self convert: result]];
  [NotificationCenter postNotificationName: AvailableNews object: nil];
}

-(void)connectionDidReceiveAuthenticationChallenge:(CPURLConnection)methodConnection
{
  alert("Authentication Challenge");
}

- (id) convert: data
{
  return [converter convert: data];
}

- (CPString) visible: data
{
  if (! data) return "[nil]";
  if (data == "") return "[empty string]";
  return data.replace(/</g, "&lt;"); // This suffices to log HTML
}


- (void) checkConnection: methodConnection  // TODO: delete?
{
  if (connection != methodConnection)
    alert("Different connections: " + connection + " received " + methodConnection + "\nPlease report this problem.");
}
  

@end
