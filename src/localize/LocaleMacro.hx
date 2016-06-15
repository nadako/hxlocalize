package localize;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

class LocaleMacro {
    static function build():Array<Field> {
        var fields = Context.getBuildFields();
        for (field in fields) {
            switch (field.kind) {
                case FVar(type, _):
                    // TODO: ensure String type?
                    field.access = [APublic];
                    field.kind = FProp('get', 'never', type, null);
                    fields.push({
                        access: [AInline],
                        kind: FFun({
                            args: [],
                            expr: macro return this.__catalog.get(new LocaleKey($v{field.name})),
                            ret: type
                        }),
                        name: 'get_' + field.name,
                        pos: field.pos,
                    });
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
                default:
            }
        }
        fields.push({
            name: "new",
            access: [APublic],
            pos: Context.currentPos(),
            kind: FFun({
                ret: null,
                args: [{name: "catalog", type: macro : Catalog}],
                expr: macro super(catalog)
            })
        });
        return fields;
    }
}
#end
