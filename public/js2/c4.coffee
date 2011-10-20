# -*- indent-tabs-mode: nil -*-

global = (exports ? this)

class global.OnStarts

  @isEmpty: (tag) ->
    tag.innerHTML.match /^\s*$/

  @hasStuff: (tag) ->
    !OnStarts.isEmpty(tag)

  @hide_empty_textile_divs: (duration) ->
    $('.textile').filter(-> OnStarts.isEmpty(this)).slideUp(duration)
    $('.textile').filter(-> OnStarts.hasStuff(this)).slideDown(duration)

  @get_note_editing_page: ->
    OnStarts.hide_empty_textile_divs(0)
    # The following prevents Safari from confusing the user
    # by falsely saying form text has never been submitted.
    $('body').attr('onbeforeunload', "")
    $('#note_form').ajaxForm {
                       target: '.textile'
                       success: ->
                          OnStarts.hide_empty_textile_divs("fast")}

  @next_month: ->
    next_month = new Date()
    next_month.setMonth(next_month.getMonth()+1)
    next_month


  @get_reservation_scheduling_page: ->
    input$ = $('#weekly_end_date')
    input$.DatePicker(
      {
        current: OnStarts.next_month(),
        calendars: 2,
        onChange: ->
          input$.val(input$.DatePickerGetDate('formatted')).DatePickerHide()

        # This is required, but I suspect it's a bug. It doesn't affect which
        # calendar is shown initially, or create a selection, or anything.
        #
        date: new Date(),
      })

