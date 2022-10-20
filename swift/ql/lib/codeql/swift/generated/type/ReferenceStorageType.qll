// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.type.Type

module Generated {
  class ReferenceStorageType extends Synth::TReferenceStorageType, Type {
    /**
     * Gets the referent type of this reference storage type.
     *
     * This includes nodes from the "hidden" AST.
     */
    Type getImmediateReferentType() {
      result =
        Synth::convertTypeFromRaw(Synth::convertReferenceStorageTypeToRaw(this)
              .(Raw::ReferenceStorageType)
              .getReferentType())
    }

    /**
     * Gets the referent type of this reference storage type.
     */
    final Type getReferentType() { result = getImmediateReferentType().resolve() }
  }
}
