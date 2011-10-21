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
      window.onbeforeunload = function() {
        return nil;
      };
      OnStarts.hide_empty_textile_divs(0);
      return $('#note_form').ajaxForm({
        target: '.textile',
        success: function() {
          return OnStarts.hide_empty_textile_divs("fast");
        }
      });
    };
    OnStarts.next_month = function() {
      var next_month;
      next_month = new Date();
      next_month.setMonth(next_month.getMonth() + 1);
      return next_month;
    };
    OnStarts.get_reservation_scheduling_page = function() {
      var input$;
      input$ = $('#weekly_end_date');
      return input$.DatePicker({
        current: OnStarts.next_month(),
        calendars: 2,
        onChange: function() {
          return input$.val(input$.DatePickerGetDate('formatted')).DatePickerHide();
        },
        date: new Date()
      });
    };
    return OnStarts;
  })();
}).call(this);
