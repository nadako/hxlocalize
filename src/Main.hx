class Gift {
    public var name:LocaleKey<Void>;
    public var message:LocaleKey<{name:String, count:Int}>;

    public function new(name:String, message:String) {
        this.name = new LocaleKey(name);
        this.message = new LocaleKey(message);
    }
}

class MyLocale extends Locale {
    function person():String;
    function message(name:String, count:Int):String;
}

class Main {
    static function main() {
        var catalog = new Catalog([
            "person" => "Dan",
            "message" => "Hi, {name} ({count} times)!",

            "pony_name" => "A pony",
            "pony_message" => "Hey, {name}, you just received {count} ponies as a gift!",
        ]);

        var pony = new Gift("pony_name", "pony_message");
        trace("Gift name: " + catalog.get(pony.name));
        trace("Gift message: " + catalog.interpolate(pony.message, {name: "Dan", count: 5}));

        var locale = new MyLocale(catalog);
        trace("Typed locale method: " + locale.message(locale.person(), 5));
    }
}
