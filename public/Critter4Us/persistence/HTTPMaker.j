@import "URIMaker.j"

@implementation HTTPMaker : URIMaker
{
}


- (CPString) animalsThatCanBeTakenOutOfServiceRoute: date
{
  return jsonURI("animals_that_can_be_taken_out_of_service")+"?date=" + date
}



@end
