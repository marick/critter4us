@import <Critter4Us/persistence/JsonToModelObjectsConverter.j>

@implementation _JsonToModelObjectsConverterTest : OJTestCase
{
}


- (void) test_that_implies_this_uses_primitives_to_model_objects_converter
{
  var input = '{"unused animals":["betsy"]}';
  var converted = [JsonToModelObjectsConverter convert: input];
  [self assert: [[[NamedObject alloc] initWithName: "betsy"]]
        equals: [converted valueForKey: 'unused animals']];
}


@end
