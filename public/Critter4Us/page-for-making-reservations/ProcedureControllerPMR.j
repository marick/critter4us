@import "NamedObjectControllerPMR.j"

@implementation ProcedureControllerPMR : NamedObjectControllerPMR
{
}

- (void) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [self usedNames] forKey: 'procedures'];
}


@end
