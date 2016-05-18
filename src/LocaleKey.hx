abstract LocaleKey<T>(String) {
    public inline function new(key:String) {
        this = key;
    }

    public inline function toString():String {
        return this;
    }
}
