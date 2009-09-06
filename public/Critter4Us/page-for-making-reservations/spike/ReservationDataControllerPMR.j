@import "../util/AwakeningObject.j"
@import "../util/Time.j"

@implementation ReservationDataControllerPMR : AwakeningObject
{
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField dateField;
  CPRadio morningButton;

  CPButton beginButton;
  CPButton reserveButton;
  CPButton restartButton;

  CPWebView linkToPreviousResults;
}

- (void) allowUserToChooseParticularCourseSession
{
  [courseField setEnabled: YES];
  [instructorField setEnabled: YES];
  [dateField setEnabled: YES];
  [morningButton setEnabled: YES];

  [beginButton setHidden: NO];
  [reserveButton setHidden: YES];
  [restartButton setHidden: YES];
}

- (void) freezeCourseSessionInput
{
  [courseField setEnabled: NO];
  [instructorField setEnabled: NO];
  [dateField setEnabled: NO];
  [morningButton setEnabled: NO];

  [beginButton setHidden: YES];
  [reserveButton setHidden: NO];
  [restartButton setHidden: NO];
}

- (void) commitToParticularCourseSession: sender
{
  [NotificationCenter postNotificationName:ReservationDataCollectedNews
                                    object:nil];
}

- (void) makeReservation: (CPButton) sender
{
  [NotificationCenter postNotificationName: WorkupHerdDataCollectedNews
                                    object: nil];
}

- (void) offerReservationView: id
{
  [linkToPreviousResults setHidden: NO];
  var href = "/reservation/" + id;
  var message = "Click to view the reservation in a new window.";
  var line1 = @"<a href='" + href + "' target=\"_blank\">" + message + "</a>";
  var line2 = "Or start another reservation using the form on the right.";
  [linkToPreviousResults loadHTMLString: '<p>' + line1 + "<br/>" + line2 + '</p>'
                                baseURL: nil];
}

- (void) abandonReservation: (CPButton) sender
{
  alert("Does nothing yet.");
}


- (id) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];
  [dict setValue: [dateField stringValue] forKey: 'date'];
  [dict setValue: [self deduceTime] forKey: 'time'];
}

// Util

- (id) deduceTime
{
  if ([morningButton state] == CPOnState) 
    return [Time morning];
  else
    return [Time afternoon];
}

- (id) setIt: (id) jsHash
{
  [courseField setStringValue: jsHash['course']];
  [instructorField setStringValue: jsHash['instructor']];
  [dateField setStringValue: jsHash['date']];
  if (jsHash['time'] === [Time morning])
    [morningButton setState: CPOnState];
  else
    [morningButton setState: CPOffState];
}

@end
