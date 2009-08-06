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




- (CPString)POSTFormData: request withFormData: content
{
  [request setHTTPMethod:@"POST"]; 
  [request setHTTPBody:content]; 
  [request setValue:"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 

  var data = [CPURLConnection sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  alert([data description]);
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
  alert("making reservation");
  var dataString = encodeURIComponent([CPString JSONFromObject: jsData]);
  var content = [CPString stringWithFormat:@"data=%s", dataString];
  alert(content);

  var request = [CPURLRequest requestWithURL:@"http://localhost:7000/json/store_reservation"];
  alert("about to POST");
  [network POSTFormData: request withFormData: content];
}

// util
- (CPArray) valueForKey: (CPString)aKey atRoute: route
{
  var url = jsonURI(route);
  alert("value for key " + url);
  var jsonString = [network GETJsonFromURL: url];
  alert("jsonstring is " + jsonString);
  var jsHash =  [jsonString objectFromJSON];
  var result = jsHash[aKey];
  return result;
}

@end

