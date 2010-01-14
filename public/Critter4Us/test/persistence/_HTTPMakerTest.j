@import <Critter4Us/persistence/HTTPMaker.j>
@import <Critter4US/test/testutil/TestUtil.j>


@implementation _HTTPMakerTest : OJTestCase
{
  URImaker maker;
}

-(void) setUp
{
  maker = [[HTTPMaker alloc] init];
}

-(void) test_can_make_uri_to_fetch_animals_that_can_be_taken_out_of_service_as_of_a_date
{
  [self assert: '/json/animals_that_can_be_taken_out_of_service?date=2009-12-30'
        equals: [maker animalsThatCanBeTakenOutOfServiceRoute: '2009-12-30']];
}




@end
