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
      $('body').attr('onbeforeunload', "");
      return $('#note_form').ajaxForm({
        target: '.textile'
      }, function() {
        return OnStarts.hide_empty_textile_div();
      });
    };
    return OnStarts;
  })();
}).call(this);
