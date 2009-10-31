@import <Critter4Us/persistence/URIMaker.j>
@import "TestUtil.j"


@implementation EditingURIMakerTest : OJTestCase
{
  URImaker maker;
}

-(void) setUp
{
  maker = [[EditingURIMaker alloc] init];
}

-(void) test_can_make_uri_to_fetch_reservation_by_id
{
  [self assert: '/json/reservation/32?ignoring=32'
        equals: [maker fetchReservationURI: 32]];
}

@end
