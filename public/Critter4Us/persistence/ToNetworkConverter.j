@import "../model/NamedObject.j"
@import "../util/Time.j"

@implementation ToNetworkConverter : CPObject
{
}

+ (id) convert: cpObject
{
  return [[[self alloc] init] convert: cpObject];
}

- (id) convert: cpObject
{
  if ([cpObject isKindOfClass: NamedObject])
  {
    return [cpObject name];
  }
  switch ([cpObject class]) {
  case CPString:
    return cpObject;
  case CPDictionary:
    return [self convertDictionary: cpObject];
  case CPArray:
    return [self convertArray: cpObject];
  case Group: 
    var animals = [self convert: [cpObject animals]];
    var procedures = [self convert: [cpObject procedures]];
    return {'animals': animals, 'procedures' : procedures};
  case Time:
    return [cpObject description];
  default:
    alert("Program error: converting unknown object '" + [cpObject description] + "' into javascript.");
  }

}

-(id) convertArray: array
{
  var jsData = [];
  var enumerator = [array objectEnumerator];
  var elt;
  while (elt = [enumerator nextObject])
    {
      var value = [self convert: elt];
      [jsData addObject: value]; // JS and Obj-J dictionaries same.
    }
  return jsData;
}

-(id)convertDictionary: dict
{
  var jsData = {};
  var enumerator = [dict keyEnumerator];
  var key;
  while (key = [enumerator nextObject])
    {
      var value = [self convert: [dict valueForKey: key]];
      jsData[key] = value;
    }
  return jsData;
}

// TODO:
// These two routines are really a hack because I haven't made the mock framework
// match invocations with same names but different arguments.


- (id) convertDate: (id) date
{
  return date;   // To hide our primitive obsession until there's a real Date object.
}

- (id) convertTime: (Time) time
{
  return [self convert: time];
}

@end
