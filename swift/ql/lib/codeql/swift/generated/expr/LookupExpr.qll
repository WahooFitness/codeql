// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.decl.Decl
import codeql.swift.elements.expr.Expr

module Generated {
  class LookupExpr extends Synth::TLookupExpr, Expr {
    /**
     * Gets the base of this lookup expression.
     *
     * This includes nodes from the "hidden" AST.
     */
    Expr getImmediateBase() {
      result =
        Synth::convertExprFromRaw(Synth::convertLookupExprToRaw(this).(Raw::LookupExpr).getBase())
    }

    /**
     * Gets the base of this lookup expression.
     */
    final Expr getBase() { result = getImmediateBase().resolve() }

    /**
     * Gets the member of this lookup expression, if it exists.
     *
     * This includes nodes from the "hidden" AST.
     */
    Decl getImmediateMember() {
      result =
        Synth::convertDeclFromRaw(Synth::convertLookupExprToRaw(this).(Raw::LookupExpr).getMember())
    }

    /**
     * Gets the member of this lookup expression, if it exists.
     */
    final Decl getMember() { result = getImmediateMember().resolve() }

    /**
     * Holds if `getMember()` exists.
     */
    final predicate hasMember() { exists(getMember()) }
  }
}
