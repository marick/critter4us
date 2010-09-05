@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerRABD : AwakeningObject
{
  TimesliceControl timesliceControl;
  CPButton reportButton;
  HTTPMaker httpMaker;
  ModelObjectsToPrimitivesConverter primitivizer;
}

- (void) report: sender
{
  var primitive = [primitivizer convert: [timesliceControl timeslice]];
  var route = [httpMaker route_reportAllAnimalsAtTimeslice_html: primitive];
  if (window.open) window.open(route); // if is for testing.
}

@end
