@import <Foundation/Foundation.j>
@import "../util/Constants.j"

@implementation Future : CPObject
{
  CPMutableString result, route, notificationName;
  
}

+ (void) spawnGetTo: network
          withRoute: route
   notificationName: notificationName
{
  var future = [[self alloc] initWithRoute: route notificationName: notificationName];
  [future sendAsynchronousGetTo: network];
}

- (id) initWithRoute: aRoute notificationName: aName
{
  self = [super init];
  route = aRoute;
  notificationName = aName;
  result = "";
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
  [network sendGetAsynchronouslyTo: [self route]
                          delegate: self];
}


-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
  alert("Fail with error");
}

-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
  result += data;
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
  [NotificationCenter postNotificationName: [self notificationName]
                                    object: result];
  [NotificationCenter postNotificationName: AvailableNews object: nil];
  [NotificationCenter removeObserver: self];
}

-(void)connectionDidReceiveAuthenticationChallenge:(CPURLConnection)connection
{
  alert("Authentication Challenge");
}

@end
