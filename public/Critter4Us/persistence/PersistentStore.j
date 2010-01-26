@import <Foundation/Foundation.j>
@import "../util/AwakeningObject.j"
@import "NetworkConnection.j"
@import "ToNetworkConverter.j"
@import "PrimitivesToModelObjectsConverter.j"
@import "HTTPMaker.j"
@import "Future.j"
@import "NetworkContinuation.j"


@import "JsonToModelObjectsConverter.j"
@import "HTTPMaker.j"

var SharedPersistentStore = nil;

@implementation PersistentStore : AwakeningObject
{
  id network;
  ToNetworkConverter toNetworkConverter;
  PrimitivesToModelObjectsConverterd primitivesConverter;
  HTTPMaker httpMaker;
  id futureMaker;
  id continuationMaker

  HTTPMaker httpMaker;
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
  primitivesConverter = [[PrimitivesToModelObjectsConverter alloc] init];
  httpMaker = [[HTTPMaker alloc] init];
  futureMaker = Future;
  continuationMaker = NetworkContinuation;

  httpMaker = [[HTTPMaker alloc] init];
}

- (void) makeHTTPWith: aHTTPMaker
{
  httpMaker = aHTTPMaker;
}

-(void) loadInfoRelevantToDate: date time: time 
{
  var url = [httpMaker reservationRouteWithDate: [toNetworkConverter convertDate: date]
                                        time: [toNetworkConverter convertTime: time]];
  var dict = [self dictionaryFromJSON: [network GETJsonFromURL: url]];
  [NotificationCenter postNotificationName: AnimalAndProcedureNews
                                    object: dict];
}

- (void) makeReservation: dict
{
  var jsData = [toNetworkConverter convert: dict];
  var postContent = [httpMaker POSTContentFrom: jsData];
  var url = [httpMaker POSTReservationRoute];
  var json = [network POSTFormDataTo: url withContent: postContent];
  var jsHash = [json objectFromJSON];
  var id = jsHash['reservation'];
  [NotificationCenter postNotificationName: ReservationStoredNews
                                    object: id];
}

- (void) fetchReservation: reservationId
{
  var continuation = [continuationMaker continuationNotifying: ReservationRetrievedNews
					  afterConvertingWith: [[JsonToModelObjectsConverter alloc] init]];
  [network get: [httpMaker fetchReservationRoute: reservationId]
	   continuingWith: continuation];
}

- (CPString) allReservationsHtml
{
  var continuation = [continuationMaker continuationNotifying: AllReservationsHtmlNews]; 
  [network get: [httpMaker route_getAllReservations_html]
	   continuingWith: continuation];
}

- (void) fetchAnimalsInServiceOnDate: (CPString) aDateString
{
  var continuation = [continuationMaker continuationNotifying: AnimalsThatCanBeRemovedFromServiceRetrieved
					  afterConvertingWith: [[JsonToModelObjectsConverter alloc] init]];
  [network get: [httpMaker route_animalsThatCanBeTakenOutOfService_data: aDateString]
	   continuingWith: continuation];
}

- (void) fetchAnimalsWithPendingReservationsOnDate: (CPString) aDateString
{
  var continuation = [continuationMaker continuationNotifying: TableOfAnimalsWithPendingReservationsNews]; 
  [network get: [httpMaker pendingReservationAnimalListWithDate: aDateString]
	   continuingWith: continuation];
}

- (void) takeAnimals: animals outOfServiceOn: (CPString) date
{
  var route = [httpMaker POSTAnimalsOutOfServiceRoute];
  var content = [httpMaker POSTContentFrom: {'date':[toNetworkConverter convert: date],
                                            'animals': [toNetworkConverter convert: animals]}];

  var continuation = [continuationMaker continuationNotifying: UniversallyIgnoredNews];
  [network postContent: content toRoute: route continuingWith: continuation];
}


// util


// TODO: This should be deletable.
- (CPDictionary) dictionaryFromJSON: (CPString) json
{
  if (! json)
  {
    alert("No JSON string received after posting. Please report this.");
    return;
  }
  var jsHash =  [json objectFromJSON];
  if (! jsHash)
  {
    alert("No hash was obtained from JSON string " + json + "\n Please report this.");
    return;
  }
  // [self log: [[CPDictionary dictionaryWithJSObject: jsHash recursively: YES] description]];
  var dictionary =  [primitivesConverter convert: jsHash]
  return dictionary;
}


@end
