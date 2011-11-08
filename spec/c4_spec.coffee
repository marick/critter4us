global = (exports ? this)

class Includeroo extends global.C4.Module
  @include global.C4.TagUtils

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

