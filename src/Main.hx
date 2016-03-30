class MyLocale extends Locale {
    function person():String;
    function message(name:String, count:Int):String;
}

class Main {
    static function main() {
        var locale = new MyLocale([
            "person" => "Dan",
            "message" => "Hi, {name} ({count})!"
        ]);
        trace(locale.message(locale.person(), 5));
    }
}
