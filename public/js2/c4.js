(function() {
  var global;
  global = typeof exports !== "undefined" && exports !== null ? exports : this;
  global.OnStarts = (function() {
    function OnStarts() {}
    OnStarts.isEmpty = function(tag) {
      return tag.innerHTML.match(/^\s*$/);
    };
    OnStarts.hide_empty_textile_div = function(duration) {
      $('.textile').filter(function() {
        return OnStarts.isEmpty(this);
      }).slideUp(duration);
      return $('.textile').filter(function() {
        return !OnStarts.isEmpty(this);
      }).slideDown(duration);
    };
    OnStarts.get_note_editing_page = function() {
      OnStarts.hide_empty_textile_div(0);
      $('body').attr('onbeforeunload', "");
      return $('#note_form').ajaxForm({
        target: '.textile',
        success: function(responseText) {
          return OnStarts.hide_empty_textile_div("fast");
        }
      });
    };
    return OnStarts;
  })();
}).call(this);
