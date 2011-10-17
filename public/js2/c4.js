(function() {
  var global;
  global = typeof exports !== "undefined" && exports !== null ? exports : this;
  global.OnStarts = (function() {
    function OnStarts() {}
    OnStarts.get_note_editing_page = function(reservation_id) {
      $('input#update_note').click(function() {
        return $.post("/2/reservation/" + reservation_id + "/note", $('form#note_form').serialize(), function() {
          return $('#note').load("/2/reservation/" + reservation_id + "/notetext");
        });
      });
      return $('#note').load("/2/reservation/" + reservation_id + "/notetext");
    };
    return OnStarts;
  })();
}).call(this);
