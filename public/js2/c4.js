(function() {
  var global;
  global = typeof exports !== "undefined" && exports !== null ? exports : this;
  global.OnStarts = (function() {
    function OnStarts() {}
    OnStarts.isEmpty = function(tag) {
      return tag.innerHTML.match(/^\s*$/);
    };
    OnStarts.hasStuff = function(tag) {
      return !OnStarts.isEmpty(tag);
    };
    OnStarts.hide_empty_textile_divs = function(duration) {
      $('.textile').filter(function() {
        return OnStarts.isEmpty(this);
      }).slideUp(duration);
      return $('.textile').filter(function() {
        return OnStarts.hasStuff(this);
      }).slideDown(duration);
    };
    OnStarts.get_note_editing_page = function() {
      OnStarts.hide_empty_textile_divs(0);
      $('body').attr('onbeforeunload', "");
      return $('#note_form').ajaxForm({
        target: '.textile',
        success: function() {
          return OnStarts.hide_empty_textile_divs("fast");
        }
      });
    };
    return OnStarts;
  })();
}).call(this);
