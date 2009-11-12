@import <Foundation/Foundation.j>
@import "Future.j"

AllReservationsTableRoute = @"reservations";  // TODO: Should this go into URIMaker?

@implementation ReservationTableFuture : Future
{
}

- (CPString) route
{
  return AllReservationsTableRoute;
}

-(CPString) notification
{
  return ReservationTableRetrievedNews
}

@end
