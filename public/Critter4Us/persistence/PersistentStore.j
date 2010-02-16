@import <Foundation/Foundation.j>
@import "../util/AwakeningObject.j"
@import "NetworkConnection.j"
@import "ModelObjectsToPrimitivesConverter.j"
@import "HTTPMaker.j"
@import "Future.j"
@import "NetworkContinuation.j"


@import "JsonToModelObjectsConverter.j"
@import "HTTPMaker.j"

var SharedPersistentStore = nil;

@implementation PersistentStore : AwakeningObject
{
  id network;
  ModelObjectsToPrimitivesConverter primitivizer;
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
  primitivizer = [[ModelObjectsToPrimitivesConverter alloc] init];
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
  var route = [httpMaker reservationRouteWithDate: [primitivizer convert: date]
					     time: [primitivizer convert: time]];
  
  var continuation = [continuationMaker continuationNotifying: AnimalAndProcedureNews
					  afterConvertingWith: [JsonToModelObjectsConverter converter]];
  [network get: route continuingWith: continuation];
}

-(void) loadInfoRelevantToTimeslice: timeslice 
{
  var route = [httpMaker animalsAndProceduresAvailableAtTimeslice: [primitivizer convert: timeslice]];
  
  var continuation = [continuationMaker continuationNotifying: AnimalAndProcedureNews
					  afterConvertingWith: [JsonToModelObjectsConverter converter]];
  [network get: route continuingWith: continuation];
}

- (void) makeReservation: dict
{
  var route = [httpMaker POSTReservationRoute];
  var jsData = [primitivizer convert: dict];
  var content = [httpMaker POSTContentFrom: jsData];

  var continuation = [continuationMaker continuationNotifying: ReservationStoredNews
					  afterConvertingWith: [JsonToModelObjectsConverter converter]];
  [network postContent: content toRoute: route continuingWith: continuation];
}

- (void) fetchReservation: reservationId
{
  var continuation = [continuationMaker continuationNotifying: ReservationRetrievedNews
					  afterConvertingWith: [JsonToModelObjectsConverter converter]];
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
					  afterConvertingWith: [JsonToModelObjectsConverter converter]];
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
  var content = [httpMaker POSTContentFrom: {'date':[primitivizer convert: date],
                                            'animals': [primitivizer convert: animals]}];

  var continuation = [continuationMaker continuationNotifying: UniversallyIgnoredNews];
  [network postContent: content toRoute: route continuingWith: continuation];
}

@end
