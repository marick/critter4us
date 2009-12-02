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
  var text = sprintf.apply(this, Array.prototype.slice.call(arguments, 2));
  var date = new Date();
  
  [log addObject: date.toLocaleTimeString() + " " + text];
}

- (CPString) text
{
  return log.join("\n");
}

@end

DefaultLogger = [[Logger alloc] init];

