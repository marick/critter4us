(function() {
  var global, moduleKeywords;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
  global = typeof exports !== "undefined" && exports !== null ? exports : this;
  if (global.C4 == null) {
    global.C4 = new Object();
  }
  moduleKeywords = ['extended', 'included'];
  global.C4.Module = (function() {
    function Module() {}
    Module.extend = function(obj) {
      var key, value, _ref;
      for (key in obj) {
        value = obj[key];
        if (__indexOf.call(moduleKeywords, key) < 0) {
          this[key] = value;
        }
      }
      if ((_ref = obj.extended) != null) {
        _ref.apply(this);
      }
      return this;
    };
    Module.include = function(obj) {
      var key, value, _ref;
      for (key in obj) {
        value = obj[key];
        if (__indexOf.call(moduleKeywords, key) < 0) {
          this.prototype[key] = value;
        }
      }
      if ((_ref = obj.included) != null) {
        _ref.apply(this);
      }
      return this;
    };
    return Module;
  })();
  global.C4.TagUtils = {
    isEmpty: function(tag) {
      return tag.innerHTML.match(/^\s*$/);
    },
    hasStuff: function(tag) {
      return !this.isEmpty(tag);
    }
  };
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
