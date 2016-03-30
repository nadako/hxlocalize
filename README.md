# hxlocalize

This is my small experiment with implementing type-safe localization in Haxe using macros.

The idea is pretty simple: you declare all possible messages as empty methods in a child class of a magic base-class, like this:

```haxe
class MyLocale extends Locale {
    function person():String;
    function message(name:String, count:Int):String;
}
```

Then create an instance of that class, passing translations map like this:

```haxe
var locale = new MyLocale([
    "person" => "Dan",
    "message" => "Hi, {name} ({count})!" // `name` and `count` match argument names
]);
```

Then just call defined methods and get translated strings:

```haxe
trace(locale.message(locale.person(), 5)); // Hi, Dan (5)!
```
