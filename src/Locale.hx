@:autoBuild(LocaleMacro.build())
class Locale {
    var __catalog:Catalog;

    function new(catalog:Catalog) {
        __catalog = catalog;
    }
}
