global = (exports ? this)

class global.OnStarts

  @get_note_editing_page: (reservation_id) ->
    $('input#update_note').click -> 
      $.post "/2/reservation/#{reservation_id}/note",
             $('form#note_form').serialize(),
             -> $('#note').load("/2/reservation/#{reservation_id}/notetext")
    $('#note').load("/2/reservation/#{reservation_id}/notetext")


