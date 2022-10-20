// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr

module Generated {
  class IfExpr extends Synth::TIfExpr, Expr {
    override string getAPrimaryQlClass() { result = "IfExpr" }

    /**
     * Gets the condition of this if expression.
     *
     * This includes nodes from the "hidden" AST.
     */
    Expr getImmediateCondition() {
      result =
        Synth::convertExprFromRaw(Synth::convertIfExprToRaw(this).(Raw::IfExpr).getCondition())
    }

    /**
     * Gets the condition of this if expression.
     */
    final Expr getCondition() { result = getImmediateCondition().resolve() }

    /**
     * Gets the then expression of this if expression.
     *
     * This includes nodes from the "hidden" AST.
     */
    Expr getImmediateThenExpr() {
      result =
        Synth::convertExprFromRaw(Synth::convertIfExprToRaw(this).(Raw::IfExpr).getThenExpr())
    }

    /**
     * Gets the then expression of this if expression.
     */
    final Expr getThenExpr() { result = getImmediateThenExpr().resolve() }

    /**
     * Gets the else expression of this if expression.
     *
     * This includes nodes from the "hidden" AST.
     */
    Expr getImmediateElseExpr() {
      result =
        Synth::convertExprFromRaw(Synth::convertIfExprToRaw(this).(Raw::IfExpr).getElseExpr())
    }

    /**
     * Gets the else expression of this if expression.
     */
    final Expr getElseExpr() { result = getImmediateElseExpr().resolve() }
  }
}
