@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerRABD : AwakeningObject
{
  DualDateControl dateControl;
  CPButton reportButton;
  HTTPMaker httpMaker;
  ModelObjectsToPrimitivesConverter primitivizer;
}

- (void) report: sender
{
  var first = [primitivizer convert: [dateControl firstDate]];
  var last = [primitivizer convert: [dateControl lastDate]];
  var route = [httpMaker route_html_usageReportFirst: first last: last];
  if (window.open) window.open(route); // if is for testing.
}

@end
