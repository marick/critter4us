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

  CPPanel groups;
  CPCollectionView collectionView;
  CPInteger pushes;
  CPArray lines;
  CPArray subset;
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
  [self freezeDateAndTimeFields];
  [self hideBegin: YES];
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

- (void) beginningOfReservationWorkflow
{
  [self enableGeneralReservationFields];
  [self hideBegin: NO];
}

- (void) abandonReservation:sender
{
  alert("This isn't implemented yet. You can achieve the same effect by reloading this page in your browser.");
}



// Util

- (void) enableGeneralReservationFields
{
  [courseField setEnabled: YES];
  [instructorField setEnabled: YES];
  [dateField setEnabled: YES];
  [morningButton setEnabled: YES];
  [afternoonButton setEnabled: YES];
}

- (void) hideBegin: value
{
  [beginButton setHidden: value];
  [restartButton setHidden: !value];
  [reserveButton setHidden: !value];
}


- (void) freezeDateAndTimeFields
{
  [dateField setEnabled: NO];
  [morningButton setEnabled: NO];
  [afternoonButton setEnabled: NO];
}


- (id) deduceTime
{
  if ([morningButton state] == CPOnState) 
    return [Time morning];
  else
    return [Time afternoon];
}


@end


