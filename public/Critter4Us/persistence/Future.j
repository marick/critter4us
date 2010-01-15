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
  CPString route, notificationName;
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

- (void) get: aRoute from: network
{
  route = aRoute;
  [self sendAsynchronousGetTo: network];
}

- (void) postContent: content toRoute: aRoute on: network
{
  route = aRoute;
  [self sendAsynchronousPostTo: network content: content];
}




/////////





+ (void) spawnGetTo: network
          withRoute: route
   notificationName: notificationName
{
  var future = [[self alloc] initWithRoute: route notificationName: notificationName];
  [future sendAsynchronousGetTo: network];
}

+ (void) spawnPostTo: network
           withRoute: route
             content: content
    notificationName: notificationName
{
  var future = [[self alloc] initWithRoute: route notificationName: notificationName];
  [future sendAsynchronousPostTo: network content: content]
}

- (id) initWithRoute: aRoute notificationName: aName
{
  self = [super init];
  route = aRoute;
  notificationName = aName;
  result = [CPString string];
  converter = [[NullConverter alloc] init];
  return self;
}

- (CPString) route
{
  return route;
}
- (CPString) notificationName
{
  return notificationName;
}


-(void) sendAsynchronousGetTo: network
{
  [NotificationCenter postNotificationName: BusyNews object: nil];
  connection = [network sendGetAsynchronouslyTo: [self route]
                                       delegate: self];
  [self log: "GET on connection %@ to %@",
        [connection hash], [self route]];
}

-(void) sendAsynchronousPostTo: network content: content
{
  [NotificationCenter postNotificationName: BusyNews object: nil];
  connection = [network POSTFormDataAsynchronouslyTo: [self route]
                                         withContent: content
                                            delegate: self];
}


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
  // if (methodConnection != connection) return; // Firefox sends spurious notifications
  [NotificationCenter postNotificationName: [self notificationName]
                                    object: [self convert: result]];
  [NotificationCenter postNotificationName: AvailableNews object: nil];
  [NotificationCenter removeObserver: self];
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
  CPMutableString result, route, notificationName;
}

-(void) sendAsynchronousGetTo: network
{
  var msg = "Future getting " + [self route] + "; will post" + [self notificationName] + "\n";
  [self log: msg];
  //  alert(msg);
  [super sendAsynchronousGetTo: network];
}

-(void) sendAsynchronousPostTo: network content: content
{
  var msg = "Future posting " + [self route] + "with content" + content + "; will post" + [self notificationName] + "\n";
  [self log: msg];
  //  alert(msg);
  [super sendAsynchronousPostTo: network content: content];
}

-(void)connection:(CPURLConnection)methodConnection didReceiveData:(CPString)data
{
  var msg = "Class" + [self class] + "/Connection" + methodConnection + ": Future for route " + [self route] + " received " + data + " to add to " + result + "\n";
  [self log: msg];
  //  alert(msg);
  [super connection: methodConnection didReceiveData: data];
}

-(void)connectionDidFinishLoading:(CPURLConnection)methodConnection
{
  var msg = "Connection" + methodConnection + ": Future for route " + [self route] + " finished with " + result + "\n";
  [self log: msg];
  alert(msg);
  [super connectionDidFinishLoading: methodConnection];
}

- (void) log: msg
{
  ChattyFutureLog += msg;
}
