@import <Foundation/Foundation.j>
@import "../util/AwakeningObject.j"
@import "NetworkConnection.j"
@import "ToNetworkConverter.j"
@import "FromNetworkConverter.j"
@import "TimeInvariantExclusionCache.j"

@implementation PersistentStore : AwakeningObject
{
  id network;
  ToNetworkConverter toNetworkConverter;
  FromNetworkConverter fromNetworkConverter;
  CPDictionary timeInvariantExclusions;
}

- (void) awakeFromCib
{
  toNetworkConverter = [[ToNetworkConverter alloc] init];
  fromNetworkConverter = [[FromNetworkConverter alloc] init];
  [self setTimeInvariantExclusions: TimeInvariantExclusionCache];
}

- (void) setTimeInvariantExclusions: json
{
  timeInvariantExclusions = [json objectFromJSON];
}


-(void) loadInfoRelevantToDate: date time: time notificationName: notificationName
{
  var url = jsonURI(CourseSessionDataBlobRoute+"?date=" + date + "&time=" + [time description]);
  
  var dict = [self dictionaryFromJSON: [network GETJsonFromURL: url]];
  [NotificationCenter postNotificationName: notificationName
                                    object: dict];
}


- (CPInteger) makeReservation: dict
{
  var dataString = [self dataStringFromDictionary: dict];
  var content = [CPString stringWithFormat:@"data=%s", dataString];
  return [self useReservationProducingRoute: StoreReservationRoute
                               withPOSTData: content];
}

// TODO: Two much duplication between this function and previous.
- (CPInteger) updateReservation: reservationID with: dict
{
  var dataString = [self dataStringFromDictionary: dict];
  var content = [CPString stringWithFormat:@"reservationID=%s&data=%s",
                          reservationID, dataString];
  return [self useReservationProducingRoute: ModifyReservationRoute
                               withPOSTData: content];
}

- (CPString) pendingReservationTableAsHtml
{
  return [network GETHtmlfromURL: AllReservationsTableRoute];
}

- (id) reservation: reservationId
{
  var url = jsonURI(GetEditableReservationRoute) + '/' + reservationId;
  return [self dictionaryFromJSON: [network GETJsonFromURL: url]];
}

// util



- (CPDictionary) dictionaryFromJSON: (CPString) json
{
  if (! json)
    alert("No JSON string received after posting. Please report this.   \nOriginal: " + json);
  var jsHash =  [json objectFromJSON];
  if (! jsHash)
    alert("No hash was obtained from JSON string " + json + "\n Please report this.");
  [self addInvariantExclusionsTo: jsHash];
  var dictionary =  [fromNetworkConverter convert: jsHash];
  return dictionary;
}

- (void) addInvariantExclusionsTo: jsHash
{
  var procedures = jsHash['procedures'];
  var exclusions = jsHash['exclusions']
  for (var i=0; i < [procedures count]; i++)
  {
    var procedureName = procedures[i];
    exclusions[procedureName] = exclusions[procedureName] || [];
    var procedureExclusions = exclusions[procedureName];
    var timeInvariants = timeInvariantExclusions[procedureName] || [];
    exclusions[procedureName] = 
        [procedureExclusions arrayByAddingObjectsFromArray: timeInvariants];
  }
}

- (CPString) dataStringFromDictionary: dict
{
  var jsData = [toNetworkConverter convert: dict];
  var json = [CPString JSONFromObject: jsData];
  return encodeURIComponent(json);
}

- (void) useReservationProducingRoute: route withPOSTData: content
{
  var url = jsonURI(route);
  var dict = [self dictionaryFromJSON: [network POSTFormDataTo: url withContent: content]];
  return [dict valueForKey: 'reservation'];
}


@end
