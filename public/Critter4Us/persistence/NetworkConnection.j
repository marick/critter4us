@import "../util/CritterObject.j"
@implementation NetworkConnection : CritterObject
{
  id connectionMaker;
  id urlMaker;
}


- (id) init
{
  self = [super init];
  connectionMaker = CPURLConnection;
  urlMaker = CPURLRequest;
  return self;
}

- (void) get: route continuingWith: continuation
{
  [self notifyBusy];
  [connectionMaker connectionWithRequest: [self GETRequest: route]
				delegate: continuation];
  [self log: "GET to %@", route];
}

- (void) postContent: content toRoute: route continuingWith: continuation
{
  [self notifyBusy];
  [connectionMaker connectionWithRequest: [self postRequest: route content: content]
				delegate: continuation];
  [self log: "POST to %@", route];
}

- (void) notifyBusy
{
  [NotificationCenter postNotificationName: BusyNews object: nil];
}

- (CPURLRequest) GETRequest: route
{
  return [urlMaker requestWithURL: route];
}

- (CPURLRequest) postRequest: route content: content
{
  var request = [CPURLRequest requestWithURL: route];
  [request setHTTPMethod:@"POST"]; 
  [request setHTTPBody:content]; 
  [request setValue:"application/x-www-form-urlencoded"
           forHTTPHeaderField:@"Content-Type"];
  return request;
}

@end
