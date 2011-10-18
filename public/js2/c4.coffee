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


  @update_textile_div: (newStuff) ->
    $('.textile').html(newStuff)

  @get_note_editing_page: (reservation_id) ->
    OnStarts.hide_empty_textile_div(0)
    $('body').attr('onbeforeunload', "")
    $('#note_form').ajaxForm {
                       target: '.textile'
                       success: (responseText) ->
                          OnStarts.hide_empty_textile_div("fast")}



