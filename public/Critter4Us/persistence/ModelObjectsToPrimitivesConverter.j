@import "../model/NamedObject.j"
@import "../util/Time.j"
@import "../util/AnimalDescription.j"

@implementation ModelObjectsToPrimitivesConverter : CPObject
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
    // case CPMutableString:    // -- no such thing in Capp 0.8.1
    return cpObject;
  case CPDictionary:
  case CPMutableDictionary:
    return [self convertDictionary: cpObject];
  case CPArray:
  case CPMutableArray:
    return [self convertArray: cpObject];
  case Group: 
    var animals = [self convert: [cpObject animals]];
    var procedures = [self convert: [cpObject procedures]];
    return {'animals': animals, 'procedures' : procedures};
  case Timeslice:
    var firstDate = [self convert: cpObject.firstDate];
    var lastDate = [self convert: cpObject.lastDate];
    var times = [self convert: cpObject.times];
    return {'firstDate': firstDate, 'lastDate': lastDate, 'times': times}; 
  case Time:
    return [cpObject description];
  case AnimalDescription:
    return {'name':cpObject.name, 'species':cpObject.species, 'note':cpObject.note};
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

@end
