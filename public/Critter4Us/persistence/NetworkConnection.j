@import "../util/CritterObject.j"
@implementation NetworkConnection : CritterObject
{
  id connectionMaker;
}


- (id) init
{
  self = [super init];
  connectionMaker = CPURLConnection;
  return self;
}


- (void) get: route continuingWith: continuation
{
  [NotificationCenter postNotificationName: BusyNews object: nil];
  var connection = [self sendGetAsynchronouslyTo: route
					delegate: continuation];
  [self log: "GET on connection %@ to %@",
        [connection hash], route];
}

- (void) postContent: content toRoute: route continuingWith: continuation
{
  [NotificationCenter postNotificationName: BusyNews object: nil];
  var connection = [self POSTFormDataAsynchronouslyTo: route
					  withContent: content
					     delegate: continuation];
}



- (CPURLConnection) sendGetAsynchronouslyTo: route delegate: delegate
{
  var request = [CPURLRequest requestWithURL: route];
  urlConnection = [connectionMaker connectionWithRequest:request delegate:delegate];
  [[Logger defaultLogger] log: "Opened and started connection %@", [urlConnection hash]];
  //  [urlConnection start];
  return urlConnection;
}

- (CPURLConnection) POSTFormDataAsynchronouslyTo: (CPString) url withContent: content delegate: delegate
{
  var request = [self postRequestForRoute: url content: content]
  urlConnection = [connectionMaker connectionWithRequest:request delegate:delegate];
  // [urlConnection start];
  return urlConnection;
}

- (CPURLRequest) postRequestForRoute: url content: content
{
  var request = [CPURLRequest requestWithURL: url];
  [request setHTTPMethod:@"POST"]; 
  [request setHTTPBody:content]; 
  [request setValue:"application/x-www-form-urlencoded"
           forHTTPHeaderField:@"Content-Type"];
  return request;
}



// TODO: Following are old-fashioned and shall be replaced.


- (CPString)GETJsonFromURL: (CPString) url
{
  var request = [CPURLRequest requestWithURL: url];
  var data = [connectionMaker sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  return [data description];
}

- (CPString)GETHtmlfromURL: (CPString) url
{
  var request = [CPURLRequest requestWithURL: url];
  var data = [connectionMaker sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  return [data description];
}

- (CPString)POSTFormDataTo: (CPString) url withContent: content
{
  var request = [self postRequestForRoute: url content: content]
  var data = [connectionMaker sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  return [data description];
}

@end
