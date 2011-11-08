# -*- indent-tabs-mode: nil -*-

global = (exports ? this)

class global.C4
  isEmpty: (tag) ->
    tag.innerHTML.match /^\s*$/

  hasStuff: (tag) ->
    !@isEmpty(tag)




class global.OnStarts

  @isEmpty: (tag) ->
    tag.innerHTML.match /^\s*$/

  @hasStuff: (tag) ->
    !@isEmpty(tag)

  @update_textile_divs_visibility: (duration) ->
    duration ?= 0
    $('.textile').filter(-> @isEmpty(this)).slideUp(duration)
    $('.textile').filter(-> @hasStuff(this)).slideDown(duration)

  @submit_note_update: ->
    $('#note_form').ajaxForm {
                       target: '.textile'
                       success: ->
                          @update_textile_divs_visibility("fast")}

  @get_note_editing_page: ->
    # The following prevents Safari from confusing the user
    # by falsely saying form text has never been submitted.
    # This used to work and mysteriously stopped.
    # $('body').attr('onbeforeunload', "")
    # But this does work. For now!
    window.onbeforeunload = -> nil
    @update_textile_divs_visibility()
    @submit_note_update()

  @next_month: ->
    next_month = new Date()
    next_month.setMonth(next_month.getMonth()+1)
    next_month

  @update_with_date_picker: (input$) ->
    input$.DatePicker({
        current: @next_month(),
        calendars: 2,
        onChange: ->
          input$.val(input$.DatePickerGetDate('formatted')).DatePickerHide()
        date: new Date(), # needs to be here, not sure why, doesn't affect the calendar shown
      })

  @get_reservation_scheduling_page: ->
    @update_with_date_picker($('#weekly_end_date'))

