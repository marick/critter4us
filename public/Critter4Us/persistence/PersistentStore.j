@import <Foundation/Foundation.j>
@import "../util/Time.j"
@import "../util/AwakeningObject.j"
@import "NetworkConnection.j"

// TODO: this is not a singleton/global object. I'm not wild about
// that because focusOnDate:time: causes state to be set in one
// "persistent store" and not in "another".

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

- (CPString) pendingReservationTableAsHtml
{
  return [network GETHtmlfromURL: AllReservationsTableRoute];
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

