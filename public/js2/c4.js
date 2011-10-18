(function() {
  var global;
  global = typeof exports !== "undefined" && exports !== null ? exports : this;
  global.OnStarts = (function() {
    function OnStarts() {}
    OnStarts.hide_empty_textile_div = function() {
      var x;
      return x = $('.textile').filter(function(index) {
        return this.innerHTML.match(/^\s*$/);
      }).addClass('hidden');
    };
    OnStarts.get_note_editing_page = function(reservation_id) {
      OnStarts.hide_empty_textile_div();
      return $('input#update_note').click(function() {
        return $.post("/2/reservation/" + reservation_id + "/note", $('form#note_form').serialize(), function() {
          update_textile_div();
          return OnStarts.hide_empty_textile_div();
        });
      });
    };
    return OnStarts;
  })();
}).call(this);
