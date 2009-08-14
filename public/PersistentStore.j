@import <Foundation/CPObject.j>
@import "Time.j"
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

- (CPArray) allAnimalInfo
{
  return [self valueForKey: 'animals' atRoute: AllAnimalsRoute];
}

- (CPArray) allProcedureNames
{
  return [self valueForKey: 'procedures' atRoute: AllProceduresRoute];
}

- (CPDictionary) exclusionsForDate: (CPString)dateString time:(Time)time
{
  var jsHash = [self valueForKey: 'exclusions' atRoute: ExclusionsRoute+"?date=" + dateString + "&time=" + [time description]];
  var retval = [CPDictionary dictionaryWithJSObject: jsHash recursively: YES];
  return retval;
}	

- (void) makeReservation: dict
{
  [self checkValidity: dict];
  var jsData = [self dictionaryToJS: dict];
  var dataString = encodeURIComponent([CPString JSONFromObject: jsData]);
  var content = [CPString stringWithFormat:@"data=%s", dataString];
  var url = jsonURI(StoreReservationRoute);
  var jsonString = [network POSTFormDataTo: url withContent: content];
  var jsHash = [jsonString objectFromJSON];
  var result = jsHash["reservation"];
  return result;
}

// util

- (void) checkValidity: (CPDictionary) dict
{
  var expected = ['date', 'time', 'procedures', 'animals', 'course', 'instructor'];
  var actual = [dict allKeys];

  [actual sortUsingSelector: @selector(compare:)];
  [expected sortUsingSelector: @selector(compare:)];

  if ([expected isEqual: actual]) return;
  alert("There's a program bug. Some invalid or missing key in " + [expected description]);
}


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
      if ([[dict valueForKey: key] isMemberOfClass: CPArray])
	jsData[key] = [dict valueForKey: key];
      else
	jsData[key] = [[dict valueForKey: key] description];
    }
  return jsData;
}

@end

