// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.decl.Decl
import codeql.swift.elements.type.Type

module Generated {
  class AnyGenericType extends Synth::TAnyGenericType, Type {
    /**
     * Gets the parent of this any generic type, if it exists.
     *
     * This includes nodes from the "hidden" AST.
     */
    Type getImmediateParent() {
      result =
        Synth::convertTypeFromRaw(Synth::convertAnyGenericTypeToRaw(this)
              .(Raw::AnyGenericType)
              .getParent())
    }

    /**
     * Gets the parent of this any generic type, if it exists.
     */
    final Type getParent() { result = getImmediateParent().resolve() }

    /**
     * Holds if `getParent()` exists.
     */
    final predicate hasParent() { exists(getParent()) }

    /**
     * Gets the declaration of this any generic type.
     *
     * This includes nodes from the "hidden" AST.
     */
    Decl getImmediateDeclaration() {
      result =
        Synth::convertDeclFromRaw(Synth::convertAnyGenericTypeToRaw(this)
              .(Raw::AnyGenericType)
              .getDeclaration())
    }

    /**
     * Gets the declaration of this any generic type.
     */
    final Decl getDeclaration() { result = getImmediateDeclaration().resolve() }
  }
}
