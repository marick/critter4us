@import "../util/AwakeningObject.j"
@import "../util/Time.j"

@implementation ReservationDataControllerPMR : AwakeningObject
{
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField dateField;
  CPRadio morningButton;
  CPRadio afternoonButton;

  CPButton beginButton;
  CPButton reserveButton;
  CPButton restartButton;

  CPWebView linkToPreviousResults;
}

- (void) beginReserving: sender
{
  var data = [CPDictionary dictionary];
  [data setValue: [dateField stringValue] forKey: 'date'];
  time = ([morningButton state] == CPOnState) ? [Time morning] : [Time afternoon];
  [data setValue: time forKey: 'time'];

  [NotificationCenter postNotificationName: ReservationDataAvailable
                                    object: data];
}

- (void) prepareToFinishReservation
{
  [self setInitialButtonage: NO];
  [linkToPreviousResults setHidden: YES];
}

- (void) makeReservation: sender
{
  [NotificationCenter postNotificationName: TimeToReserveNews object: nil];
}

- (id) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];
  [dict setValue: [dateField stringValue] forKey: 'date'];
  [dict setValue: [self deduceTime] forKey: 'time'];
}

- (id) offerReservationView: reservationID
{
  var href = "/reservation/" + reservationID;
  var message = "Click to view the reservation in a new window.";
  [linkToPreviousResults loadHTMLString:@"<a href='" + href + "' target=\"_blank\">" + message + "</a>"
               baseURL: nil];
  [linkToPreviousResults setHidden: NO];
}

- (void) restart
{
  [self allowDataChanges];
  [self setInitialButtonage: YES];
}


// Util

- (void) allowNoDataChanges
{
  [self setEnabledControls: NO];
}

- (void) allowDataChanges
{
  [self setEnabledControls: YES];
}

- (void) setInitialButtonage: value
{
  [beginButton setHidden: !value];
  [restartButton setHidden: value];
  [reserveButton setHidden: value];
}

- (void) setEnabledControls: value
{
  [courseField setEnabled: value];
  [instructorField setEnabled: value];
  [dateField setEnabled: value];
  [morningButton setEnabled: value];
  [afternoonButton setEnabled: value];
  [beginButton setEnabled: value];
}

- (id) deduceTime
{
  if ([morningButton state] == CPOnState) 
    return [Time morning];
  else
    return [Time afternoon];
}


@end
