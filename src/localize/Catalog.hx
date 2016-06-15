package localize;

class Catalog {
    var data:Map<String,String>;

    public function new(data:Map<String,String>) {
        this.data = data;
    }

    public function get(key:LocaleKey<Void>):String {
        var s = data[key.toString()];
        if (s == null)
            return 'NOT LOCALIZED: $key';
        else
            return s;
    }

    public function interpolate<T:{}>(key:LocaleKey<T>, args:T):String {
        var s = data[key.toString()];
        if (s == null)
            return 'NOT LOCALIZED: $key';

        var re = ~/\{(\w+)\}/;
        var buf = new StringBuf();
        while (true) {
            if (re.match(s)) {
                buf.add(re.matchedLeft());
                var v = Reflect.field(args, re.matched(1));
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
