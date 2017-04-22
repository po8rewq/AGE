package age.utils;

class HtmlUtils
{

    public static var VENDOR_PREFIXES = ["webkit", "moz", "ms", "o", "khtml"];
    public static function loadExtension(pName: String, ?obj: Dynamic): Extension
    {
        if(obj == null)
            obj = js.Browser.window;

        var extension = Reflect.field(obj, pName);
        if (extension != null)
            return {prefix: "", field: pName, value: extension};

        // Look through common vendor prefixes
        var capitalized = pName.charAt(0).toUpperCase() + pName.substr(1);
        for (prefix in VENDOR_PREFIXES) {
            var field = prefix + capitalized;
            var extension = Reflect.field(obj, field);
            if (extension != null)
                return {prefix: prefix, field: field, value: extension};
        }

        // Not found
        return {prefix: null, field: null, value: null};
    }

}

typedef Extension = {
    var prefix  : String;
    var field   : String;
    var value   : Dynamic;
}
