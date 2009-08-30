@import <Foundation/CPObject.j>
@import "util/Time.j"
@import "util/AwakeningObject.j"

@implementation NetworkConnection : CPObject
{
  CPArray allAnimalNames;
  id kindMap;   // TODO: this should probably turn into a dictionary.
  CPDictionary exclusions;
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

  CPArray allAnimalNames;
  CPArray allProcedureNames;
  id kindMap;
  CPDictionary exclusions;
}

- (void) focusOnDate: date time: time
{
  var url = jsonURI(CourseSessionDataBlobRoute+"?date=" + date + "&time=" + [time description]);
  var jsonString = [network GETJsonFromURL: url];
  var jsHash =  [jsonString objectFromJSON];
  var d = [CPDictionary dictionaryWithJSObject: jsHash];
  allAnimalNames = jsHash['animals'];
  allProcedureNames = jsHash['procedures'];
  kindMap = jsHash['kindMap'];
  exclusions = [CPDictionary dictionaryWithJSObject: jsHash['exclusions']];
}

- (CPInteger) makeReservation: dict
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

