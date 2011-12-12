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
    setFixtures("<input type='text' id='weekly_end_date'/>")
    @sut = new global.C4.RepetitionAddingPage
    @sut.initialize_jquery()

  it "can stash dates that are picked", ->
    $(@sut.weekly_end_date_input$).DatePickerSetDate(new Date(2011, 5, 3))
    @sut.make_date_picker_stasher(@sut.weekly_end_date_input$)()
    expect(@sut.weekly_end_date_input$).toHaveValue("2011-06-03")

