// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr

module Generated {
  class ForceValueExpr extends Synth::TForceValueExpr, Expr {
    override string getAPrimaryQlClass() { result = "ForceValueExpr" }

    /**
     * Gets the sub expression of this force value expression.
     *
     * This includes nodes from the "hidden" AST.
     */
    Expr getImmediateSubExpr() {
      result =
        Synth::convertExprFromRaw(Synth::convertForceValueExprToRaw(this)
              .(Raw::ForceValueExpr)
              .getSubExpr())
    }

    /**
     * Gets the sub expression of this force value expression.
     */
    final Expr getSubExpr() { result = getImmediateSubExpr().resolve() }
  }
}
