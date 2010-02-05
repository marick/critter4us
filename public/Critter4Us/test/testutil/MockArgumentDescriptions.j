// Predicate generators, typically used to describe expected objects.

Some = function(expected) {
  return function(actual) {
    return expected == [actual class];
  }
}
  
Containing_at_least = function(expected) {
  return function(actual) {
    for (var key in expected) 
    {
      // Note that this equality test won't work for all objects.
      if (! [expected[key] isEqual: actual[key]]) return NO;
    }
    return YES;
  }
}

