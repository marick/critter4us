@implementation Logger : CPObject
{
  CPArray log;
}

+ (id) defaultLogger
{
  return DefaultLogger;
}

- (id) init
{
  log = [CPArray array];
  return self;
}

- (void) log: (CPString) format, ...
{
  var text = ObjectiveJ.sprintf.apply(this, Array.prototype.slice.call(arguments, 2));
  var date = new Date();
  text = text.replace('<', '[')
  [log addObject: date.toLocaleTimeString() + " " + text];
}

- (CPString) text
{
  return log.join("\n");
}

@end

DefaultLogger = [[Logger alloc] init];

