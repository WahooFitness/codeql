// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.AstNode
import codeql.swift.elements.type.Type

module Generated {
  /**
   * The base class for all expressions in Swift.
   */
  class Expr extends Synth::TExpr, AstNode {
    /**
     * Gets the type of this expression, if it exists.
     *
     * This includes nodes from the "hidden" AST.
     */
    Type getImmediateType() {
      result = Synth::convertTypeFromRaw(Synth::convertExprToRaw(this).(Raw::Expr).getType())
    }

    /**
     * Gets the type of this expression, if it exists.
     */
    final Type getType() { result = getImmediateType().resolve() }

    /**
     * Holds if `getType()` exists.
     */
    final predicate hasType() { exists(getType()) }
  }
}
