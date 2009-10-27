@import "NamedObjectControllerPMR.j"

@implementation AnimalControllerPMR : NamedObjectControllerPMR.j
{
}


- (void) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [self usedNames] forKey: 'animals'];
}



@end
