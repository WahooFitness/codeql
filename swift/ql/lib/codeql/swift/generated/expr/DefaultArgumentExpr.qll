// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.decl.ParamDecl

module Generated {
  class DefaultArgumentExpr extends Synth::TDefaultArgumentExpr, Expr {
    override string getAPrimaryQlClass() { result = "DefaultArgumentExpr" }

    /**
     * Gets the parameter declaration of this default argument expression.
     *
     * This includes nodes from the "hidden" AST.
     */
    ParamDecl getImmediateParamDecl() {
      result =
        Synth::convertParamDeclFromRaw(Synth::convertDefaultArgumentExprToRaw(this)
              .(Raw::DefaultArgumentExpr)
              .getParamDecl())
    }

    /**
     * Gets the parameter declaration of this default argument expression.
     */
    final ParamDecl getParamDecl() { result = getImmediateParamDecl().resolve() }

    /**
     * Gets the parameter index of this default argument expression.
     */
    int getParamIndex() {
      result =
        Synth::convertDefaultArgumentExprToRaw(this).(Raw::DefaultArgumentExpr).getParamIndex()
    }

    /**
     * Gets the caller side default of this default argument expression, if it exists.
     *
     * This includes nodes from the "hidden" AST.
     */
    Expr getImmediateCallerSideDefault() {
      result =
        Synth::convertExprFromRaw(Synth::convertDefaultArgumentExprToRaw(this)
              .(Raw::DefaultArgumentExpr)
              .getCallerSideDefault())
    }

    /**
     * Gets the caller side default of this default argument expression, if it exists.
     */
    final Expr getCallerSideDefault() { result = getImmediateCallerSideDefault().resolve() }

    /**
     * Holds if `getCallerSideDefault()` exists.
     */
    final predicate hasCallerSideDefault() { exists(getCallerSideDefault()) }
  }
}
