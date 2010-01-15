@import <Foundation/Foundation.j>
@import "../util/CritterObject.j"
@import "../util/Constants.j"

@implementation NullConverter : CPObject

- (id) convert: data
{
  return data;
}

@end

@implementation Future : CritterObject
{
  CPString result;
  CPString notificationName;
  CPURLConnection connection;
  id converter;
}

+ (Future) futureToAccomplish: notificationName convertingResultsWith: converter
{
  return [[Future alloc] initWithNotificationName: notificationName
                                        converter: converter];
}

+ (Future) futureToAccomplish: notificationName
{
  return [[Future alloc] initWithNotificationName: notificationName
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

- (void) get: route from: network
{
  [NotificationCenter postNotificationName: BusyNews object: nil];
  connection = [network sendGetAsynchronouslyTo: route
                                       delegate: self];
  [self log: "GET on connection %@ to %@",
        [connection hash], route];
}

- (void) postContent: content toRoute: route on: network
{
  [NotificationCenter postNotificationName: BusyNews object: nil];
  connection = [network POSTFormDataAsynchronouslyTo: route
                                         withContent: content
                                            delegate: self];
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

ChattyFutureLog = "";

@implementation ChattyFuture : Future
{
}

- (void) get: route from: network
{
  var msg = "Future getting " + route + "; will post" + [self notificationName] + "\n";
  [self log: msg];
  //  alert(msg);
  [super get: route from: network];
}

- (void) postContent: content toRoute: route on: network
{
  var msg = "Future posting " + route + "with content" + content + "; will post" + [self notificationName] + "\n";
  [self log: msg];
  //  alert(msg);
  [super postContent: content toRoute: route on: network];
}

-(void)connection:(CPURLConnection)methodConnection didReceiveData:(CPString)data
{
  var msg = "Class" + [self class] + "/Connection" + methodConnection + ": Future for route " + route + " received " + data + " to add to " + result + "\n";
  [self log: msg];
  //  alert(msg);
  [super connection: methodConnection didReceiveData: data];
}

-(void)connectionDidFinishLoading:(CPURLConnection)methodConnection
{
  var msg = "Connection" + methodConnection + ": Future for route " + route + " finished with " + result + "\n";
  [self log: msg];
  alert(msg);
  [super connectionDidFinishLoading: methodConnection];
}

- (void) log: msg
{
  ChattyFutureLog += msg;
}
