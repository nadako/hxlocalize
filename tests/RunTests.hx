package;

import haxe.unit.*;
import localize.*;

#if flash
import flash.system.System.*;
#else
import Sys.*;
#end

class RunTests extends TestCase {

    static function main() {
        var runner = new TestRunner();
        runner.add(new RunTests());
        exit(runner.run() ? 0 : 500);
    }

    function testCatalog() {
        var catalog = new Catalog([
            "pony_name" => "A pony",
            "pony_message" => "Hey, {name}, you just received {count} ponies as a gift!",
        ]);
        var pony = new Gift("pony_name", "pony_message");
        assertEquals('A pony', catalog.get(pony.name));
        assertEquals('Hey, Dan, you just received 5 ponies as a gift!' ,catalog.interpolate(pony.message, {name: "Dan", count: 5}));
    }

    function testLocale() {
        var catalog = new Catalog([
            "item" => "Apple",
            "person" => "Dan",
            "message" => "Hi, {name} ({count} times)!",
        ]);
        var locale = new MyLocale(catalog);
        assertEquals('Hi, Dan (5 times)!', locale.message(locale.person(), 5));
        assertEquals('Apple', locale.item);
    }

    function testMissingCatalogEntry() {
        var catalog = new Catalog([
            "message" => "Hi, {name} ({count} times)!",
        ]);
        var locale = new MyLocale(catalog);
        assertEquals('Hi, NOT LOCALIZED: person (5 times)!', locale.message(locale.person(), 5));
        assertEquals('NOT LOCALIZED: item', locale.item);
    }
  
}
class Gift {
    public var name:LocaleKey<Void>;
    public var message:LocaleKey<{name:String, count:Int}>;

    public function new(name:String, message:String) {
        this.name = new LocaleKey(name);
        this.message = new LocaleKey(message);
    }
}

class MyLocale extends Locale {
    var item:String;
    function person():String;
    function message(name:String, count:Int):String;
}