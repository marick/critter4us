@import <Foundation/CPSet.j>

@implementation CPSet (Bugfixes)


- (BOOL) containsObject: (id) anObject
{
    var obj = _contents[[anObject UID]];

    if (obj !== undefined && [obj isEqual:anObject])
        return YES;
    // Is it ever possible for the UID to match and obj NOT to be 
    // isEqual: to anObject?

    // No exact match, so search.
    for (var property in _contents)
    {
      if (_contents.hasOwnProperty(property))
        if ([anObject isEqual: _contents[property]])
          return YES;
    }
    return NO;
}
@end

