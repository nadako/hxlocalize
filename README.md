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

I think there are several benefits with this approach, such as:

 * you can't make a typo in your locale key, since it's a real method, known at compile-time
 * you get autocompletion and refactoring support for your locale keys
 * localized string interpolation arguments are well-defined and typed
 * it's easy to validate the translation data files from a macro using method definitions
