global = (exports ? this)

class global.OnStarts

  @isEmpty: (tag) ->
    tag.innerHTML.match /^\s*$/

  @hasStuff: (tag) ->
    !OnStarts.isEmpty(tag)  

  @hide_empty_textile_divs: (duration) -> 
    $('.textile').filter(-> OnStarts.isEmpty(this)).slideUp(duration)
    $('.textile').filter(-> OnStarts.hasStuff(this)).slideDown(duration)

  @get_note_editing_page:  ->
    OnStarts.hide_empty_textile_divs(0)
    # The following prevents Safari from confusing the user
    # by falsely saying form text has never been submitted.
    $('body').attr('onbeforeunload', "")
    $('#note_form').ajaxForm {
                       target: '.textile'
                       success: ->
                          OnStarts.hide_empty_textile_divs("fast")}
