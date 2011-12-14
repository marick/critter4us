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

  shift_day: (starting_date, count) ->
    retval = new Date(starting_date)
    retval.setDate(retval.getDate() + count)
    retval

  shift_week: (starting_date, count) ->
    @shift_day(starting_date, count*7)

  same_weekday_in_future: (candidate, today) ->
    today = new Date() unless today?
    return false unless candidate.getDay() == today.getDay()
    return false unless candidate > today
    true

  dates_within: (omitted_start, included_end, step_size = 1, so_far = []) ->
    next = @shift_day(omitted_start, step_size)
    if next <= included_end
      @dates_within(next, included_end, step_size, so_far.concat([next]))
    else
      so_far

  chatty_date_format: (date) ->
    date.toDateString()

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


class global.C4.RepetitionAddingPage extends global.C4.Module
  @include global.C4.DateUtils

  make_date_picker_stasher: (input$) ->
    -> input$.val(input$.DatePickerGetDate('formatted')).DatePickerHide()

  describe_date_picker: (input$, reservation_date) ->
    input$.DatePicker({
        current: @next_month(reservation_date),
        calendars: 2,
        onChange: @make_date_picker_stasher(input$)
        date: new Date(), # needs to be here, not sure why, doesn't affect the calendar shown
        onRender: (d) =>
          {disabled: !@same_weekday_in_future(d, reservation_date)}
      })

  chosen_date: ->
    @weekly_end_date_input$.DatePickerGetDate(false)

  # put_repetition: (reservation_id, starting_date, days_to_shift) ->
  #   $.post("/2/reservations/#{reservation_id}/repetitions",
  #          {days_to_shift: days_to_shift},
  #          ((data) =>
  #            alert(data["blah"])
  #            @next_repetition(starting_date, days_to_shift)),
  #         "json")


  # next_repetition: (starting_date, days_to_shift) ->
  #   new_starting_date = @shift_day(starting_date, days_to_shift)
  #   alert("#{new_starting_date} <= #{@chosen_date()}: #{new_starting_date <= @chosen_date()}")
  #   if new_starting_date <= @chosen_date()
  #     @put_repetition(@reservation_id, new_starting_date, days_to_shift)
    #
  ajax_duplicate: ->

  populate_dates: (omitted_start, included_end, step_size_in_days) ->
    dates = @dates_within(omitted_start, included_end, step_size_in_days)
    target$ = $('div#progress_container')
    template$ = $('#templates .repetition_progress')
    for date, i in dates
      progress = template$.clone()
      progress.children('.date').text(@chatty_date_format(date))
      progress.data('day_shift', step_size_in_days * (i+1))
      progress.appendTo(target$)

    $('#progress_container .repetition_progress')

  add_repetitions: (desired$) ->
    if desired$.length > 0
      @ajax_duplicate(@reservation_id,
                      desired$.slice(0,1).data('day_shift'),
                      desired$.slice(1))


  initialize_jquery: (reservation_id, reservation_date) ->
    @reservation_id = reservation_id
    @weekly_end_date_input$ = $('#weekly_end_date')
    @describe_date_picker(@weekly_end_date_input$, reservation_date)
    $('#duplicate_by_week').click(=>
      divs_representing_repetitions$ = @populate_dates(reservation_date, @chosen_date(), 7)
      @add_repetitions(divs_representing_repetitions$))

