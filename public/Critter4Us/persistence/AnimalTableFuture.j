@import <Foundation/Foundation.j>
@import "Future.j"

AllAnimalsTableRoute = @"animals";  // Should this go into URIMaker?


@implementation AnimalTableFuture : Future
{
}

- (CPString) route
{
  return AllAnimalsTableRoute;
}

-(CPString) notification
{
  return AnimalTableRetrievedNews;
}

@end
