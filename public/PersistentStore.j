@import <Foundation/CPObject.j>
@import "AwakeningObject.j"

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
  return [data description];
}


@end

@implementation PersistentStore : AwakeningObject
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

- (void) makeReservation: dict
{
  var jsData = [self dictionaryToJS: dict];
  var dataString = encodeURIComponent([CPString JSONFromObject: jsData]);
  var content = [CPString stringWithFormat:@"data=%s", dataString];
  url = jsonURI(StoreReservationRoute);
  var jsonString = [network POSTFormDataTo: url withContent: content];
  var jsHash = [jsonString objectFromJSON];
  var result = jsHash["reservation"];
  return result;
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

- (id) dictionaryToJS: dict
{
  var jsData = {};
  var enumerator = [dict keyEnumerator];
  var key;
  while (key = [enumerator nextObject])
    {
      jsData[key] = [dict valueForKey: key];
    }
  return jsData;
}

@end

