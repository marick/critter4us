(function() {
  var global, moduleKeywords;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
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
  global.C4.DateUtils = {
    next_month: function(starting_date) {
      var next_month;
      if (starting_date == null) {
        starting_date = new Date();
      }
      next_month = new Date(starting_date);
      next_month.setMonth(next_month.getMonth() + 1);
      return next_month;
    },
    shift_day: function(starting_date, count) {
      var retval;
      retval = new Date(starting_date);
      retval.setDate(retval.getDate() + count);
      return retval;
    },
    shift_week: function(starting_date, count) {
      return this.shift_day(starting_date, count * 7);
    },
    same_weekday_in_future: function(candidate, today) {
      if (today == null) {
        today = new Date();
      }
      if (candidate.getDay() !== today.getDay()) {
        return false;
      }
      if (!(candidate > today)) {
        return false;
      }
      return true;
    }
  };
  global.C4.Textile = {
    update_textile_divs_visibility: function(duration) {
      var self;
      if (duration == null) {
        duration = 0;
      }
      self = this;
      $('.textile').filter(function(index) {
        return self.isEmpty(this);
      }).slideUp(duration);
      return $('.textile').filter(function(index) {
        return self.hasStuff(this);
      }).slideDown(duration);
    }
  };
  global.C4.NoteEditingPage = (function() {
    __extends(NoteEditingPage, global.C4.Module);
    function NoteEditingPage() {
      NoteEditingPage.__super__.constructor.apply(this, arguments);
    }
    NoteEditingPage.include(global.C4.TagUtils);
    NoteEditingPage.include(global.C4.Textile);
    NoteEditingPage.prototype.describe_update_action = function() {
      return $('#note_form').ajaxForm({
        target: '.textile',
        success: __bind(function() {
          return this.update_textile_divs_visibility("fast");
        }, this)
      });
    };
    NoteEditingPage.prototype.initialize_jquery = function() {
      window.onbeforeunload = function() {
        return nil;
      };
      this.update_textile_divs_visibility();
      return this.describe_update_action();
    };
    return NoteEditingPage;
  })();
  global.C4.RepetitionAddingPage = (function() {
    __extends(RepetitionAddingPage, global.C4.Module);
    function RepetitionAddingPage() {
      RepetitionAddingPage.__super__.constructor.apply(this, arguments);
    }
    RepetitionAddingPage.include(global.C4.DateUtils);
    RepetitionAddingPage.prototype.make_date_picker_stasher = function(input$) {
      return function() {
        return input$.val(input$.DatePickerGetDate('formatted')).DatePickerHide();
      };
    };
    RepetitionAddingPage.prototype.describe_date_picker = function(input$, reservation_date) {
      return input$.DatePicker({
        current: this.next_month(reservation_date),
        calendars: 2,
        onChange: this.make_date_picker_stasher(input$),
        date: new Date(),
        onRender: __bind(function(d) {
          return {
            disabled: !this.same_weekday_in_future(d, reservation_date)
          };
        }, this)
      });
    };
    RepetitionAddingPage.prototype.initialize_jquery = function(reservation_id, reservation_date) {
      this.reservation_id = reservation_id;
      this.weekly_end_date_input$ = $('#weekly_end_date');
      return this.describe_date_picker(this.weekly_end_date_input$, reservation_date);
    };
    return RepetitionAddingPage;
  })();
}).call(this);
