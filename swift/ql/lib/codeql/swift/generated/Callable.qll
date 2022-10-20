// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.stmt.BraceStmt
import codeql.swift.elements.Element
import codeql.swift.elements.decl.ParamDecl

module Generated {
  class Callable extends Synth::TCallable, Element {
    /**
     * Gets the self parameter of this callable, if it exists.
     *
     * This includes nodes from the "hidden" AST.
     */
    ParamDecl getImmediateSelfParam() {
      result =
        Synth::convertParamDeclFromRaw(Synth::convertCallableToRaw(this)
              .(Raw::Callable)
              .getSelfParam())
    }

    /**
     * Gets the self parameter of this callable, if it exists.
     */
    final ParamDecl getSelfParam() { result = getImmediateSelfParam().resolve() }

    /**
     * Holds if `getSelfParam()` exists.
     */
    final predicate hasSelfParam() { exists(getSelfParam()) }

    /**
     * Gets the `index`th parameter of this callable (0-based).
     *
     * This includes nodes from the "hidden" AST.
     */
    ParamDecl getImmediateParam(int index) {
      result =
        Synth::convertParamDeclFromRaw(Synth::convertCallableToRaw(this)
              .(Raw::Callable)
              .getParam(index))
    }

    /**
     * Gets the `index`th parameter of this callable (0-based).
     */
    final ParamDecl getParam(int index) { result = getImmediateParam(index).resolve() }

    /**
     * Gets any of the parameters of this callable.
     */
    final ParamDecl getAParam() { result = getParam(_) }

    /**
     * Gets the number of parameters of this callable.
     */
    final int getNumberOfParams() { result = count(getAParam()) }

    /**
     * Gets the body of this callable, if it exists.
     *
     * This includes nodes from the "hidden" AST.
     */
    BraceStmt getImmediateBody() {
      result =
        Synth::convertBraceStmtFromRaw(Synth::convertCallableToRaw(this).(Raw::Callable).getBody())
    }

    /**
     * Gets the body of this callable, if it exists.
     * The body is absent within protocol declarations.
     */
    final BraceStmt getBody() { result = getImmediateBody().resolve() }

    /**
     * Holds if `getBody()` exists.
     */
    final predicate hasBody() { exists(getBody()) }
  }
}
