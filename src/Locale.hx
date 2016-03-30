@:autoBuild(LocaleMacro.build())
class Locale {
    var __data:Map<String,String>;

    function new(data:Map<String,String>) __data = data;

    function __localize(key:String, args:Map<String,String>):String {
        var s = __data[key];
        if (s == null)
            return 'NOT LOCALIZED: $key';

        if (args == null)
            return s;

        var re = ~/\{(\w+)\}/;
        var buf = new StringBuf();
        while (true) {
            if (re.match(s)) {
                buf.add(re.matchedLeft());
                var v = args[re.matched(1)];
                if (v == null)
                    v = "NO VALUE";
                buf.add(v);
                s = re.matchedRight();
            } else {
                buf.add(s);
                break;
            }
        }
        return buf.toString();
    }
}
