global = (exports ? this)

describe 'C4 -- currently all the coffeescript', ->
  describe 'base class', ->
    beforeEach ->
      @sut = new global.C4

    it 'can detect if a tag has no text in its inner HTML', ->
      tag = document.createElement('h1')
      expect(@sut.isEmpty(tag)).toBeTruthy()
      expect(@sut.hasStuff(tag)).toBeFalsy()

      tag.innerHTML = "text"
      expect(@sut.isEmpty(tag)).toBeFalsy()
      expect(@sut.hasStuff(tag)).toBeTruthy()

