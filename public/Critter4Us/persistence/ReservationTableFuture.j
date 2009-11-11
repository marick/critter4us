@import <Foundation/Foundation.j>
@import "../util/Constants.j"

@implementation ReservationTableFuture : CPObject
{
  CPMutableString result;
}

+ (void) spawnRequestTo: network
{
  [[[self alloc] init] sendAsynchronousRequestTo: network];
}

- (id) init
{
  self = [super init];
  result = "";
  return self;
}


-(void) sendAsynchronousRequestTo: network
{
  [NotificationCenter postNotificationName: BusyNews object: nil];
  [network sendGetAsynchronouslyTo: AllReservationsTableRoute
                       delegate: self];
}


-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
  alert("Fail with error");
}

-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
  result += data;
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
  [NotificationCenter postNotificationName: ReservationTableRetrievedNews
                                    object: result];
  [NotificationCenter postNotificationName: AvailableNews object: nil];
}

-(void)connectionDidReceiveAuthenticationChallenge:(CPURLConnection)connection
{
  alert("Authentication Challenge");
}

@end
