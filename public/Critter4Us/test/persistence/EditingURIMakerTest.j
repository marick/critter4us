@import <Critter4Us/persistence/URIMaker.j>
@import <Critter4Us/test/testutil/TestUtil.j>


@implementation EditingURIMakerTest : OJTestCase
{
  URImaker maker;
}

-(void) setUp
{
  maker = [[EditingURIMaker alloc] initEditing: 19];
}

-(void) test_can_make_uri_to_fetch_reservation_by_id
{
  // The program-as-is will always use the same number for both bits
  // of the URI, but they're conceptually different
  [self assert: '/json/reservation/333?ignoring=19'
        equals: [maker fetchReservationURI: 333]];
}

-(void) test_when_building__fetch_by_date_time__uri_exclude_reservation_being_edited
{
  [self assert: '/json/course_session_data_blob?date=2009-12-30&time=morning&ignoring=19'
        equals: [maker reservationURIWithDate: '2009-12-30' time: 'morning']];
}

-(void) test_chooses_to_modify_a_reservation_when_storing
{
  [self assert: '/json/modify_reservation'
        equals: [maker POSTReservationURI]];
}

-(void) test_identifies_reservation_to_overwrite_when_modifying
{
  var data = {'aaa':'bbb'};
  [self assert: "data=%7B%22aaa%22%3A%22bbb%22%7D&reservationID=19"
        equals: [maker POSTContentFrom: data]];
}



@end
