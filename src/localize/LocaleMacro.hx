package localize;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

class LocaleMacro {
    static function build():Array<Field> {
        var fields = Context.getBuildFields();
        var keys = [];
        var ignoredFields = [];
        
        for (field in fields) {
            switch (field.kind) {
                case FFun(fun) if (fun.expr == null):
                    field.access = [APublic, AInline];
                    if (fun.args.length > 0) {
                        var argsExpr = {
                            pos: field.pos,
                            expr: EObjectDecl([for (arg in fun.args) {field: arg.name, expr: macro $i{arg.name}}])
                        };
                        fun.expr = macro return this.__catalog.interpolate(new LocaleKey($v{field.name}), $argsExpr);
                    } else {
                        fun.expr = macro return this.__catalog.get(new LocaleKey($v{field.name}));
                    }
                    keys.push(macro $v{field.name});
                default:
                    // deliberately ignore var and props, as they mask the fact that there is an underlying function call
                    ignoredFields.push(field.name);
                  
            }
        }
        
        if(Context.defined('hxlocalize_verbose') && ignoredFields.length > 0)
            Context.warning('The following fields are ignored by hxlocalize: ' + ignoredFields.join(', '), Context.currentPos());
        
        fields.push({
            name: "new",
            access: [APublic],
            pos: Context.currentPos(),
            kind: FFun({
                ret: null,
                args: [
                    {name: "catalog", type: macro : Catalog},
                    {name: "pos", type: macro : haxe.PosInfos, opt: true},
                ],
                expr: macro $b{{
                    var exprs = [];
                    if(Context.defined('hxlocalize_runtime_check'))
                        exprs.push(macro
                            for(key in $a{keys}) if(!catalog.exists(key))
                                haxe.Log.trace('Missing localization for: "' + key + '"', pos)
                        );
                    exprs.push(macro super(catalog));
                    exprs;
                }}
            })
        });
        return fields;
    }
}
#end
