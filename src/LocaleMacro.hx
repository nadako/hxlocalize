import haxe.macro.Context;
import haxe.macro.Expr;

class LocaleMacro {
    static function build():Array<Field> {
        var fields = Context.getBuildFields();
        for (field in fields) {
            switch (field.kind) {
                case FFun(fun) if (fun.expr == null):
                    var argsExpr, isInline = false;
                    if (fun.args.length > 0) {
                        var args = [for (arg in fun.args) macro $v{arg.name} => Std.string($i{arg.name})];
                        argsExpr = macro $a{args};
                    } else {
                        argsExpr = macro null;
                        isInline = true;
                    }
                    fun.expr = macro return this.__localize($v{field.name}, $argsExpr);
                    field.access = [APublic];
                    if (isInline) field.access.push(AInline);
                default:
            }
        }
        fields.push({
            name: "new",
            access: [APublic],
            pos: Context.currentPos(),
            kind: FFun({
                ret: null,
                args: [{name: "data", type: null}],
                expr: macro super(data)
            })
        });
        return fields;
    }
}
