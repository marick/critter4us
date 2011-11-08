# -*- indent-tabs-mode: nil -*-

global = (exports ? this)
global.C4 = new Object() unless global.C4?

# From http://arcturo.github.com/library/coffeescript/03_classes.html
moduleKeywords = ['extended', 'included']

class global.C4.Module
  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value

    obj.extended?.apply(@)
    this

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    this


global.C4.TagUtils =
  isEmpty: (tag) ->
    tag.innerHTML.match /^\s*$/

  hasStuff: (tag) ->
    !@isEmpty(tag)

global.C4.DateUtils =
  next_month: (starting_date) ->
    starting_date = new Date() unless starting_date?
    next_month = new Date(starting_date)
    next_month.setMonth(next_month.getMonth()+1)
    next_month

global.C4.Textile =
  update_textile_divs_visibility: (duration) ->
    duration ?= 0
    self=this
    $('.textile').filter( (index) -> self.isEmpty(this)).slideUp(duration)
    $('.textile').filter( (index) -> self.hasStuff(this)).slideDown(duration)


class global.C4.NoteEditingPage extends global.C4.Module
  @include global.C4.TagUtils
  @include global.C4.Textile

  describe_update_action: ->
    $('#note_form').ajaxForm {
                       target: '.textile'
                       success: =>
                          @update_textile_divs_visibility("fast")}

  initialize_jquery: ->
    # The following prevents Safari from confusing the user
    # by falsely saying form text has never been submitted.
    # This used to work and mysteriously stopped.
    # $('body').attr('onbeforeunload', "")
    # But this does work. For now!
    window.onbeforeunload = -> nil
    @update_textile_divs_visibility()
    @describe_update_action()


class global.C4.ReservationSchedulingPage extends global.C4.Module
  @include global.C4.DateUtils

  make_date_picker_stasher: (input$) ->
    -> input$.val(input$.DatePickerGetDate('formatted')).DatePickerHide()

  describe_date_picker: (input$) ->
    input$.DatePicker({
        current: @next_month(),
        calendars: 2,
        onChange: @make_date_picker_stasher(input$)
        date: new Date(), # needs to be here, not sure why, doesn't affect the calendar shown
      })

  initialize_jquery: ->
    @weekly_end_date_input$ = $('#weekly_end_date')
    @describe_date_picker(@weekly_end_date_input$)
