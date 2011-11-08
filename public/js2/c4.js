(function() {
  var global;
  global = typeof exports !== "undefined" && exports !== null ? exports : this;
  global.C4 = (function() {
    function C4() {}
    C4.prototype.isEmpty = function(tag) {
      return tag.innerHTML.match(/^\s*$/);
    };
    C4.prototype.hasStuff = function(tag) {
      return !this.isEmpty(tag);
    };
    return C4;
  })();
  global.OnStarts = (function() {
    function OnStarts() {}
    OnStarts.isEmpty = function(tag) {
      return tag.innerHTML.match(/^\s*$/);
    };
    OnStarts.hasStuff = function(tag) {
      return !OnStarts.isEmpty(tag);
    };
    OnStarts.update_textile_divs_visibility = function(duration) {
      if (duration == null) {
        duration = 0;
      }
      $('.textile').filter(function() {
        return OnStarts.isEmpty(this);
      }).slideUp(duration);
      return $('.textile').filter(function() {
        return OnStarts.hasStuff(this);
      }).slideDown(duration);
    };
    OnStarts.submit_note_update = function() {
      return $('#note_form').ajaxForm({
        target: '.textile',
        success: function() {
          return OnStarts.update_textile_divs_visibility("fast");
        }
      });
    };
    OnStarts.get_note_editing_page = function() {
      window.onbeforeunload = function() {
        return nil;
      };
      OnStarts.update_textile_divs_visibility();
      return OnStarts.submit_note_update();
    };
    OnStarts.next_month = function() {
      var next_month;
      next_month = new Date();
      next_month.setMonth(next_month.getMonth() + 1);
      return next_month;
    };
    OnStarts.update_with_date_picker = function(input$) {
      return input$.DatePicker({
        current: OnStarts.next_month(),
        calendars: 2,
        onChange: function() {
          return input$.val(input$.DatePickerGetDate('formatted')).DatePickerHide();
        },
        date: new Date()
      });
    };
    OnStarts.get_reservation_scheduling_page = function() {
      return OnStarts.update_with_date_picker($('#weekly_end_date'));
    };
    return OnStarts;
  })();
}).call(this);
