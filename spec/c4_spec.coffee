global = (exports ? this)

class Includeroo extends global.C4.Module
  @include global.C4.TagUtils
  @include global.C4.DateUtils
  @include global.C4.Textile

describe 'all of C4 modules', ->
  beforeEach ->
    @sut = new Includeroo

  describe 'Tag utils', ->
    it 'can detect if a tag has no text in its inner HTML', ->
      tag = document.createElement('h1')
      expect(@sut.isEmpty(tag)).toBeTruthy()
      expect(@sut.hasStuff(tag)).toBeFalsy()

      tag.innerHTML = "text"
      expect(@sut.isEmpty(tag)).toBeFalsy()
      expect(@sut.hasStuff(tag)).toBeTruthy()

  describe 'DateUtils', ->
    describe "next_month", ->
      it 'can move the date forward', ->
        starting_date = new Date(2011, 2, 18)
        next_month = @sut.next_month(starting_date)
        expect(next_month.getFullYear()).toBe(2011)
        expect(next_month.getMonth()).toBe(3)
        expect(next_month.getDate()).toBe(18)

      it "uses today's date if none is given", ->
        expected = new Date()
        expected.setMonth(expected.getMonth()+1) # Take advantage of date rollover in Dec.
        next_month = @sut.next_month()
        expect(next_month.getMonth()).toBe(expected.getMonth())

      it "can move two months if at end of month, but that's OK", ->
        starting_date = new Date(2001, 0, 31)
        next_month = @sut.next_month(starting_date)
        expect(next_month.getDate()).toBe(3)

      it "can handle December", ->
        starting_date = new Date(2011, 11, 20)
        next_month = @sut.next_month(starting_date)
        expect(next_month.getFullYear()).toBe(2012)
        expect(next_month.getMonth()).toBe(0)
        expect(next_month.getDate()).toBe(20)


    describe "shift_week", ->
      it "can go backwards", ->
        expect(@sut.shift_week(new Date(2011, 11, 8), -1)).toEqual(new Date(2011, 11, 1))
      it "can go backwards over a month boundary", ->
        expect(@sut.shift_week(new Date(2011, 11, 8), -5)).toEqual(new Date(2011, 10, 3))

    describe "date_format", ->
      it "can format dates the way we like", ->
        expect(@sut.chatty_date_format(new Date(2011, 0, 1))).toEqual('Sat Jan 01 2011')
        expect(@sut.chatty_date_format(new Date(2011, 10, 11))).toEqual('Fri Nov 11 2011')


    # Note these tests will fail if run across day boundary
    describe "same_weekday_in_future", ->
      it "disallows today", ->
        candidate = new Date()
        expect(@sut.same_weekday_in_future(candidate)).toBeFalsy()
      it "disallows last week", ->
        candidate = @sut.shift_week(new Date(), -1)
        expect(@sut.same_weekday_in_future(candidate)).toBeFalsy()
      it "disallows tomorrow", ->
        candidate = @sut.shift_day(new Date(), 1)
        expect(@sut.same_weekday_in_future(candidate)).toBeFalsy()
      it "allows next week", ->
        candidate = @sut.shift_week(new Date(), 1)
        expect(@sut.same_weekday_in_future(candidate)).toBeTruthy()

  describe "dates_within", ->
    it "does not include the starting date", ->
      actual = @sut.dates_within(new Date(2000, 1, 1), new Date(2000, 1, 1))
      expect(actual).toEqual([])
    it "does include the ending date", ->
      actual = @sut.dates_within(new Date(2000, 1, 1), new Date(2000, 1, 2))
      expect(actual).toEqual([new Date(2000, 1, 2)])
    it "can take a step size", ->
      actual = @sut.dates_within(new Date(2000, 1, 1), new Date(2000, 1, 5), 2)
      expect(actual).toEqual([new Date(2000, 1, 3), new Date(2000, 1, 5)])
    it "omits ending date if [first, last] is not an integral multiple of step size", ->
      actual = @sut.dates_within(new Date(2000, 1, 1), new Date(2000, 1, 6), 2)
      expect(actual).toEqual([new Date(2000, 1, 3), new Date(2000, 1, 5)])



  describe 'Textile', ->
    it "will reveal a div with contents", ->
      setFixtures("<div class='textile'>text</div>")
      $('.textile').hide()
      expect($('.textile')).toBeHidden()
      @sut.update_textile_divs_visibility(0)
      expect($('.textile')).toBeVisible()

    it "hide a div with no contents", ->
      setFixtures("<div class='textile'></div>")
      expect($('.textile')).toBeVisible()
      @sut.update_textile_divs_visibility(0)
      expect($('.textile')).toBeHidden()



describe 'RepetitionAddingPage', ->
  beforeEach ->
    setFixtures("<div>
                   <input type='text' id='weekly_end_date'/>
                   <input id='duplicate_by_week' type='submit'/>
                   <div id='progress_container'/>
                   <div id='templates'>
                      <div class='repetition_progress'>
                        <p class='date' om='f'>
                      </div>
                   </div>
                 </div>")
    @sut = new global.C4.RepetitionAddingPage
    @arbitrary_date = new Date(2011, 5, 3)
    @sut.initialize_jquery("reservation_id", @arbitrary_date)

  it "can stash dates that are picked", ->
    $(@sut.weekly_end_date_input$).DatePickerSetDate(new Date(2012, 6, 5))
    @sut.make_date_picker_stasher(@sut.weekly_end_date_input$)()
    expect(@sut.weekly_end_date_input$).toHaveValue("2012-07-05")

  it "can query chosen dates", ->
    $(@sut.weekly_end_date_input$).DatePickerSetDate(@arbitrary_date)
    expect(@sut.chosen_date()).toEqual(@arbitrary_date)

  it "can respond to a button click by making and processing templates", ->
    chosen_date = @sut.shift_week(@arbitrary_date, 2)
    $(@sut.weekly_end_date_input$).DatePickerSetDate(chosen_date)

    spyOn(@sut, 'populate_dates').andReturn(["div1$", "div2$"])
    spyOn(@sut, 'add_repetitions')
    $('#duplicate_by_week').click()
    expect(@sut.populate_dates).toHaveBeenCalledWith(@arbitrary_date, chosen_date, 7)
    expect(@sut.add_repetitions).toHaveBeenCalledWith(["div1$", "div2$"])

  describe "Duplicating a template", ->
    beforeEach ->
      @week_count = 2
      two_weeks_later = @sut.shift_week(@arbitrary_date, @week_count)
      @actual$ = @sut.populate_dates(@arbitrary_date, two_weeks_later, 7)
      @instantiated$ = $("#progress_container .repetition_progress")

    it "adds the right number of instantiated elements", ->
      expect(@instantiated$.length).toEqual(@week_count)

    it "returns those elements", ->
      expect(@actual$).toEqual(@instantiated$)

    it "puts the target date inside the appropriate paragraph (visibly)", ->
      dates = $('#progress_container .repetition_progress').
              map(-> $.trim($(this).text())).
              get()
      expect(dates).toEqual([@sut.chatty_date_format(@sut.shift_week(@arbitrary_date, 1)),
                             @sut.chatty_date_format(@sut.shift_week(@arbitrary_date, 2))])

    it "stashes the target date (as a date) where later functions can get at it.", ->
      shifts = @instantiated$.map(-> $(this).data('day_shift')).get()
      expect(shifts).toEqual([7, 14])

    describe "Sending repetitions", ->
      beforeEach ->
        spyOn(@sut, 'ajax_duplicate')

      it "invokes the (untestable) ajax function", ->
        @sut.add_repetitions(@actual$)

        expect(@sut.ajax_duplicate).
          toHaveBeenCalledWith("reservation_id",
                               7, # first day shift
                               @actual$.slice(1))  # remainder to be processed

      it "does nothing when the wrapped elements are exhausted", ->
        @sut.add_repetitions($())
        expect(@sut.ajax_duplicate).not.toHaveBeenCalled()

      # it "uses a callback to send the next request", ->
      #   spyOn(@sut, 'ajax_duplicate').andCallFake(-> @sut.add_repetitions(@actual$.slice(1)))

      #   @sut.add_repetitions(@actual$)

      #   expect(@sut.ajax_duplicate).
      #     toHaveBeenCalledWith("reservation_id",
      #                          7, # first day shift
      #                          @actual$.slice(1))





