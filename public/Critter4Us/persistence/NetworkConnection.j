@import <Foundation/Foundation.j>
@implementation NetworkConnection : CPObject
{
}


- (CPString)GETJsonFromURL: (CPString) url
{
  var request = [CPURLRequest requestWithURL: url];
  var data = [CPURLConnection sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  return [data description];
}

- (CPString)GETHtmlfromURL: (CPString) url
{
  var request = [CPURLRequest requestWithURL: url];
  var data = [CPURLConnection sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  return [data description];
}

- (CPString)POSTFormDataTo: (CPString) url withContent: content
{
  var request = [self postRequestForRoute: url content: content]
  var data = [CPURLConnection sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  return [data description];
}

- (CPURLConnection) POSTFormDataAsynchronouslyTo: (CPString) url withContent: content delegate: delegate
{
  var request = [self postRequestForRoute: url content: content]
  urlConnection = [CPURLConnection connectionWithRequest:request delegate:delegate];
  [urlConnection start];
  return urlConnection;
}

- (CPURLConnection) sendGetAsynchronouslyTo: route delegate: delegate
{
  var request = [CPURLRequest requestWithURL: route];
  urlConnection = [CPURLConnection connectionWithRequest:request delegate:delegate];
  [urlConnection start];
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

@end
