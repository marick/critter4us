@import <Foundation/Foundation.j>
@import "../util/Time.j"
@import "../model/Animal.j"
@import "../model/Procedure.j"
@import "../util/AwakeningObject.j"
@import "NetworkConnection.j"
@import "JavaScripter.j"

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

-(void) loadInfoRelevantToDate: date time: time
{
  [self focusOnDate: date time: time];
  // Doing this rigamarole with dictionaryWithJSObject because the commented-out
  // code below produces a doubly-nested array when a singly-nested one is put 
  // in.
  var animals = [self animals];
  var procedures = [self procedures];
  var jsdict = {'animals':animals, 'procedures':procedures}
  var dict = [CPDictionary dictionaryWithJSObject: jsdict];
  //  var a = [self animals];
  //  CPLog("++++++++ puting animals in " + [a description]);
  //  [dict setValue: a forKey: 'animals'];
  //  [dict setValue: [self procedures] forKey: 'procedures'];
  // CPLog("++++++++ taking animals out " + [[dict valueForKey: 'animals'] description]);
  [NotificationCenter postNotificationName: InitialDataForACourseSessionNews
                                    object: dict];
}

- (CPArray) animals
{
  return [self animalsFromNames: allAnimalNames];
}

- (CPArray) animalsFromNames: someNames
{
  var result = [CPArray array];
  for(var i = 0; i < [someNames count]; i++)
  {
    var name = someNames[i];
    [result addObject: [[Animal alloc] initWithName: name kind: kindMap[name]]];
  }
  return result;
}

- (CPArray) procedures
{
  var result = [CPArray array];
  var keys = [exclusions allKeys];
  for(var i = 0; i < [keys count]; i++)
  {
    var name = keys[i];
    var animalNames =  [exclusions valueForKey: name];
    var animals = [self animalsFromNames: animalNames];
    [result addObject: [[Procedure alloc] initWithName: name
                                             excluding: animals]];
  }
  return result;
}

- (CPInteger) makeReservation: dict
{
  [self checkValidity: dict];
  var jsData = [JavaScripter parse: dict];
  var json = [CPString JSONFromObject: jsData];
  var dataString = encodeURIComponent(json);
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
  var expected = ['date', 'time', 'groups', 'course', 'instructor'];
  var actual = [dict allKeys];

  [actual sortUsingSelector: @selector(compare:)];
  [expected sortUsingSelector: @selector(compare:)];

  if ([expected isEqual: actual]) return;
  alert("There's a program bug. Some invalid or missing key in " + [expected description]);
}



@end

