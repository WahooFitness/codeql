// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.UnresolvedElement

module Generated {
  class UnresolvedDotExpr extends Synth::TUnresolvedDotExpr, Expr, UnresolvedElement {
    override string getAPrimaryQlClass() { result = "UnresolvedDotExpr" }

    /**
     * Gets the base of this unresolved dot expression.
     *
     * This includes nodes from the "hidden" AST.
     */
    Expr getImmediateBase() {
      result =
        Synth::convertExprFromRaw(Synth::convertUnresolvedDotExprToRaw(this)
              .(Raw::UnresolvedDotExpr)
              .getBase())
    }

    /**
     * Gets the base of this unresolved dot expression.
     */
    final Expr getBase() { result = getImmediateBase().resolve() }

    /**
     * Gets the name of this unresolved dot expression.
     */
    string getName() {
      result = Synth::convertUnresolvedDotExprToRaw(this).(Raw::UnresolvedDotExpr).getName()
    }
  }
}
