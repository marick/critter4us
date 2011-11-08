global = (exports ? this)

class Includeroo extends global.C4.Module
  @include global.C4.TagUtils
  @include global.C4.DateUtils
  @include global.C4.Textile

describe 'all of C4', ->
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
    it 'can move the date forward', ->
      starting_date = new Date(2011, 2, 18)
      next_month = @sut.next_month(starting_date)
      expect(next_month.getFullYear()).toBe(2011)
      expect(next_month.getMonth()).toBe(3)
      expect(next_month.getDate()).toBe(18)

    it "uses today's date if none is given", ->
      now = new Date()
      next_month = @sut.next_month()
      expect(next_month.getMonth()).toBe(now.getMonth()+1)

    it "can move two months, but that's OK", ->
      starting_date = new Date(2001, 0, 31)
      next_month = @sut.next_month(starting_date)
      expect(next_month.getDate()).toBe(3)
