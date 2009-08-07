@import <Foundation/CPObject.j>
@import "Controller.j"

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

- (CPString)POSTFormDataTo: (CPString) url withContent: content
{
  var request = [CPURLRequest requestWithURL: url];
  [request setHTTPMethod:@"POST"]; 
  [request setHTTPBody:content]; 
  [request setValue:"application/x-www-form-urlencoded"
           forHTTPHeaderField:@"Content-Type"]; 

  var data = [CPURLConnection sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  alert([data description]);
  return [data description];
}


@end

@implementation PersistentStore : Controller
{
  id network;
}

- (CPArray) allAnimalNames
{
  return [self valueForKey: 'animals' atRoute: AllAnimalsRoute];
}

- (CPArray) allProcedureNames
{
  return [self valueForKey: 'procedures' atRoute: AllProceduresRoute];
}

- (CPDictionary) exclusionsForDate: (CPString)dateString
{
  var jsHash = [self valueForKey: 'exclusions' atRoute: ExclusionsRoute+"?date=" + dateString];
  var retval = [CPDictionary dictionaryWithJSObject: jsHash recursively: YES];
  return retval;
}	

- (void) makeReservation: jsData
{
  var dataString = encodeURIComponent([CPString JSONFromObject: jsData]);
  var content = [CPString stringWithFormat:@"data=%s", dataString];
  url = jsonURI(StoreReservationRoute);
  [network POSTFormDataTo: url withContent: content];
}

// util
- (CPArray) valueForKey: (CPString)aKey atRoute: route
{
  var url = jsonURI(route);
  var jsonString = [network GETJsonFromURL: url];
  var jsHash =  [jsonString objectFromJSON];
  var result = jsHash[aKey];
  return result;
}

@end

