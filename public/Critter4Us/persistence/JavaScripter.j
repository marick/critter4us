@import "../model/NamedObject.j"
@import "../util/Time.j"

@implementation JavaScripter : CPObject
{
}

+ (id) parse: cpObject
{
  return [[[self alloc] init] parse: cpObject];
}

- (id) parse: cpObject
{
  if ([cpObject isKindOfClass: NamedObject])
  {
    return [cpObject name];
  }
  switch ([cpObject class]) {
  case CPString:
    return cpObject;
  case CPDictionary:
    return [self parseDictionary: cpObject];
  case CPArray:
    return [self parseArray: cpObject];
  case Group: 
    var animals = [self parse: [cpObject animals]];
    var procedures = [self parse: [cpObject procedures]];
    return {'animals': animals, 'procedures' : procedures};
  case Time:
    return [cpObject description];
  default:
    alert("Program error: converting unknown object '" + [cpObject description] + "' into javascript.");
  }

}

-(id) parseArray: array
{
  var jsData = [];
  var enumerator = [array objectEnumerator];
  var elt;
  while (elt = [enumerator nextObject])
    {
      var value = [self parse: elt];
      [jsData addObject: value]; // JS and Obj-J dictionaries same.
    }
  return jsData;
}

-(id)parseDictionary: dict
{
  var jsData = {};
  var enumerator = [dict keyEnumerator];
  var key;
  while (key = [enumerator nextObject])
    {
      var value = [self parse: [dict valueForKey: key]];
      jsData[key] = value;
    }
  return jsData;
}

@end
