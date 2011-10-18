global = (exports ? this)

class global.OnStarts

  @hide_empty_textile_div: -> 
    $('.textile').filter (index) ->
      this.innerHTML.match /^\s*$/
    .hide("slow")
    $('.textile').filter (index) ->
      !this.innerHTML.match(/^\s*$/)
    .show("slow")


  @update_textile_div: (newStuff) ->
    $('.textile').html(newStuff)

  @get_note_editing_page: (reservation_id) ->
    OnStarts.hide_empty_textile_div()
    $('input#update_note').click -> 
      $.post "/2/reservation/#{reservation_id}/note",
             $('form#note_form').serialize(), (data) ->  
               OnStarts.update_textile_div(data)
               OnStarts.hide_empty_textile_div()


 # @get_note_editing_page: (reservation_id) ->
 #   $('input#update_note').click -> 
 #     $.post "/2/reservation/#{reservation_id}/note",
 #            $('form#note_form').serialize(),
 #            -> $('#note').load("/2/reservation/#{reservation_id}/notetext")
 #   $('#note').load("/2/reservation/#{reservation_id}/notetext")

