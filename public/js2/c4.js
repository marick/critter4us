(function() {
  var global;
  global = typeof exports !== "undefined" && exports !== null ? exports : this;
  global.OnStarts = (function() {
    function OnStarts() {}
    OnStarts.hide_empty_textile_div = function() {
      $('.textile').filter(function(index) {
        return this.innerHTML.match(/^\s*$/);
      }).hide("slow");
      return $('.textile').filter(function(index) {
        return !this.innerHTML.match(/^\s*$/);
      }).show("slow");
    };
    OnStarts.update_textile_div = function(newStuff) {
      return $('.textile').html(newStuff);
    };
    OnStarts.get_note_editing_page = function(reservation_id) {
      OnStarts.hide_empty_textile_div();
      return $('input#update_note').click(function() {
        return $.post("/2/reservation/" + reservation_id + "/note", $('form#note_form').serialize(), function(data) {
          OnStarts.update_textile_div(data);
          return OnStarts.hide_empty_textile_div();
        });
      });
    };
    return OnStarts;
  })();
}).call(this);
