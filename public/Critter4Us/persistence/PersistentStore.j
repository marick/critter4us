@import <Foundation/Foundation.j>
@import "../util/AwakeningObject.j"
@import "NetworkConnection.j"
@import "ToNetworkConverter.j"
@import "FromNetworkConverter.j"

@implementation PersistentStore : AwakeningObject
{
  id network;
}

-(void) loadInfoRelevantToDate: date time: time
{
  var url = jsonURI(CourseSessionDataBlobRoute+"?date=" + date + "&time=" + [time description]);
  
  var dict = [self dictionaryFromJSON: [network GETJsonFromURL: url]];
  [NotificationCenter postNotificationName: InitialDataForACourseSessionNews
                                    object: dict];
}


- (CPInteger) makeReservation: dict
{
  [self checkReservationValidity: dict];
  var dataString = [self dataStringFromDictionary: dict];
  var content = [CPString stringWithFormat:@"data=%s", dataString];
  var url = jsonURI(StoreReservationRoute);
  var dict = [self dictionaryFromJSON: [network POSTFormDataTo: url withContent: content]];
  return [dict valueForKey: 'reservation'];
}


- (CPString) pendingReservationTableAsHtml
{
  return [network GETHtmlfromURL: AllReservationsTableRoute];
}

- (id) reservation: reservationId
{
  var url = jsonURI(GetReservationRoute) + '/' + reservationId;
  return [self dictionaryFromJSON: [network GETJsonFromURL: url]];
}

// util


- (void) checkReservationValidity: (CPDictionary) dict
{
  var expected = ['date', 'time', 'groups', 'course', 'instructor'];
  var actual = [dict allKeys];

  [actual sortUsingSelector: @selector(compare:)];
  [expected sortUsingSelector: @selector(compare:)];

  if ([expected isEqual: actual]) return;
  alert("There's a program bug. Some invalid or missing key in " + [expected description]);
}

- (CPDictionary) dictionaryFromJSON: (CPString) json
{
  if (! json)
    alert("No JSON string received after posting. Please report this.   \nOriginal: " + json);
  var jsHash =  [json objectFromJSON];
  if (! jsHash)
    alert("No hash was obtained from JSON string " + json + "\n Please report this.");
  return [FromNetworkConverter convert: jsHash];
}

- (CPString) dataStringFromDictionary: dict
{
  var jsData = [ToNetworkConverter convert: dict];
  var json = [CPString JSONFromObject: jsData];
  return encodeURIComponent(json);
}

@end
