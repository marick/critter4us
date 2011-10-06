if (C4 == null || typeof(C4) != "object") {
    var C4 = new Object();
}
if (C4.util == null || typeof(C4.util) != "object") {
    C4.util = new Object();
}


C4.util = {
    column_propagator : function(selector) {
        return function() {
            var starting_at = $(selector).index(this) + 1
            $(selector).slice(starting_at).val(this.value);
        };
    },

    select_column_propagator : function(selector) {
        return function() {
            var starting_at = $(selector).index(this) + 1;
            $(selector).slice(starting_at).val(this.value);
            var new_default = this.value;
            var all_options = $(selector).slice(starting_at).children("option")
            all_options.removeAttr("selected");
            all_options.filter(function() { return this.value == new_default }).attr("selected", "selected");
        };
    },

    duplicate_before : function(template_selector, count, destination) {
        return function() {
            var row$ = $(template_selector);
            for (var i = 0; i < count; i++) {
                row$.clone().insertBefore(destination);
         }
        }
    },

    number_name : function(elts$, tag) {
        elts$.each(function (index) {
            $(this).attr("name", tag + "[" + index + "]");
        })
    }
};
