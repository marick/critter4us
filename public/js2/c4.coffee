global = (exports ? this)

class global.OnStarts

  @isEmpty: (tag) ->
    tag.innerHTML.match /^\s*$/

  @hide_empty_textile_div: (duration) -> 
    $('.textile').filter ->
      OnStarts.isEmpty(this)
    .slideUp(duration)
    $('.textile').filter ->
      !OnStarts.isEmpty(this)
    .slideDown(duration)

  @get_note_editing_page:  ->
    OnStarts.hide_empty_textile_div(0)
    # The following prevents Safari from confusing the user
    # by falsely saying form text has never been submitted.
    $('body').attr('onbeforeunload', "")
    $('#note_form').ajaxForm {
                       target: '.textile'
                       success: (responseText) ->
                          OnStarts.hide_empty_textile_div("fast")}
