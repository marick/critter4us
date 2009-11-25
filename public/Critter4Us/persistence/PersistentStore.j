@import <Foundation/Foundation.j>
@import "../util/AwakeningObject.j"
@import "NetworkConnection.j"
@import "ToNetworkConverter.j"
@import "FromNetworkConverter.j"
@import "TimeInvariantExclusionCache.j"
@import "URIMaker.j"
@import "Future.j"

var SharedPersistentStore = nil;

@implementation PersistentStore : AwakeningObject
{
  id network;
  ToNetworkConverter toNetworkConverter;
  FromNetworkConverter fromNetworkConverter;
  CPDictionary timeInvariantExclusions;
  URIMaker uriMaker;
}

+ (PersistentStore) sharedPersistentStore
{
  if (!SharedPersistentStore)
  {
    SharedPersistentStore = [[PersistentStore alloc] init];
    SharedPersistentStore.network = [[NetworkConnection alloc] init];
    [SharedPersistentStore awakeFromCib];
  }
  return SharedPersistentStore;
}


- (void) awakeFromCib
{
  if (awakened) return;
  [super awakeFromCib]
  toNetworkConverter = [[ToNetworkConverter alloc] init];
  fromNetworkConverter = [[FromNetworkConverter alloc] init];
  uriMaker = [[URIMaker alloc] init];

  [self setTimeInvariantExclusions: TimeInvariantExclusionCache];
}

- (void) setTimeInvariantExclusions: jsonString
{
  timeInvariantExclusions = [jsonString objectFromJSON];
}

- (void) makeURIsWith: aURIMaker
{
  uriMaker = aURIMaker;
}

-(void) loadInfoRelevantToDate: date time: time 
{
  var url = [uriMaker reservationURIWithDate: [toNetworkConverter convertDate: date]
                                        time: [toNetworkConverter convertTime: time]];
  var dict = [self dictionaryFromJSON: [network GETJsonFromURL: url]];
  [NotificationCenter postNotificationName: AnimalAndProcedureNews
                                    object: dict];
}

- (void) makeReservation: dict
{
  var jsData = [toNetworkConverter convert: dict];
  var postContent = [uriMaker POSTReservationContentFrom: jsData];
  var url = [uriMaker POSTReservationURI];
  var json = [network POSTFormDataTo: url withContent: postContent];
  var jsHash = [json objectFromJSON];
  var id = jsHash['reservation'];
  [NotificationCenter postNotificationName: ReservationStoredNews
                                    object: id];
}

- (void) fetchReservation: reservationId
{
  var url = [uriMaker fetchReservationURI: reservationId];
  var dict = [self dictionaryFromJSON: [network GETJsonFromURL: url]];
  [NotificationCenter postNotificationName: ReservationRetrievedNews
                                    object: dict];
}

- (CPString) pendingReservationTableAsHtml
{
  [Future spawnGetTo: network
           withRoute: AllReservationsTableRoute
    notificationName: ReservationTableRetrievedNews];
}

- (CPString) animalTableAsHtml
{
  [Future spawnGetTo: network
           withRoute: AllAnimalsTableRoute
    notificationName: AnimalTableRetrievedNews];
}

- (void) fetchAnimalDeletionData
{
  [Future spawnGetTo: network
           withRoute: AnimalDeletionInfoRoute
    notificationName: AnimalDeletionInfoRetrievedNews];
}


// util


- (CPDictionary) dictionaryFromJSON: (CPString) json
{
  if (! json)
    alert("No JSON string received after posting. Please report this.   \nOriginal: " + json);
  var jsHash =  [json objectFromJSON];
  if (! jsHash)
    alert("No hash was obtained from JSON string " + json + "\n Please report this.");
  // CPLog([[CPDictionary dictionaryWithJSObject: jsHash] description]);
  var dictionary =  [fromNetworkConverter convert: jsHash
                              withAddedExclusions: timeInvariantExclusions];
  return dictionary;
}



@end
