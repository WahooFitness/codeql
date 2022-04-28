/**
 * @name XML external entity expansion
 * @description Parsing user-controlled XML documents and allowing expansion of
 *              external entity references may lead to disclosure of
 *              confidential data or denial of service.
 * @kind path-problem
 * @id cpp/external-entity-expansion
 * @problem.severity warning
 * @security-severity 9.1
 * @precision medium
 * @tags security
 *       external/cwe/cwe-611
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import DataFlow::PathGraph
import semmle.code.cpp.ir.IR

/**
 * A flow state representing a possible configuration of an XML object.
 */
abstract class XXEFlowState extends DataFlow::FlowState {
  bindingset[this]
  XXEFlowState() { any() } // required characteristic predicate
}

/**
 * An `Expr` that changes the configuration of an XML object, transforming the
 * `XXEFlowState` that flows through it.
 */
abstract class XXEFlowStateTranformer extends Expr {
  /**
   * Gets the flow state that `flowstate` is transformed into.
   *
   * Due to limitations of the implementation the transformation defined by this
   * predicate must be idempotent, that is, for any input `x` it must be that:
   * ```
   * transform(tranform(x)) = tranform(x)
   * ```
   */
  abstract XXEFlowState transform(XXEFlowState flowstate);
}

/**
 * The `AbstractDOMParser` class.
 */
class AbstractDOMParserClass extends Class {
  AbstractDOMParserClass() { this.hasName("AbstractDOMParser") }
}

/**
 * The `XercesDOMParser` class.
 */
class XercesDOMParserClass extends Class {
  XercesDOMParserClass() { this.hasName("XercesDOMParser") }
}

/**
 * The `SAXParser` class.
 */
class SAXParser extends Class {
  SAXParser() { this.hasName("SAXParser") }
}

/**
 * Gets a valid flow state for `AbstractDOMParser` or `SAXParser` flow.
 *
 * These flow states take the form `Xerces-A-B`, where:
 *  - A is 1 if `setDisableDefaultEntityResolution` is `true`, 0 otherwise.
 *  - B is 1 if `setCreateEntityReferenceNodes` is `true`, 0 otherwise.
 */
predicate encodeXercesFlowState(
  string flowstate, int disabledDefaultEntityResolution, int createEntityReferenceNodes
) {
  flowstate = "Xerces-0-0" and
  disabledDefaultEntityResolution = 0 and
  createEntityReferenceNodes = 0
  or
  flowstate = "Xerces-0-1" and
  disabledDefaultEntityResolution = 0 and
  createEntityReferenceNodes = 1
  or
  flowstate = "Xerces-1-0" and
  disabledDefaultEntityResolution = 1 and
  createEntityReferenceNodes = 0
  or
  flowstate = "Xerces-1-1" and
  disabledDefaultEntityResolution = 1 and
  createEntityReferenceNodes = 1
}

/**
 * A flow state representing the configuration of a `AbstractDOMParser` or
 * `SAXParser` object.
 */
class XercesFlowState extends XXEFlowState {
  XercesFlowState() { encodeXercesFlowState(this, _, _) }
}

/**
 * A flow state transformer for a call to
 * `AbstractDOMParser.setDisableDefaultEntityResolution` or
 * `SAXParser.setDisableDefaultEntityResolution`. Transforms the flow
 * state through the qualifier according to the setting in the parameter.
 */
class DisableDefaultEntityResolutionTranformer extends XXEFlowStateTranformer {
  Expr newValue;

  DisableDefaultEntityResolutionTranformer() {
    exists(Call call, Function f |
      call.getTarget() = f and
      (
        f.getDeclaringType() instanceof AbstractDOMParserClass or
        f.getDeclaringType() instanceof SAXParser
      ) and
      f.hasName("setDisableDefaultEntityResolution") and
      this = call.getQualifier() and
      newValue = call.getArgument(0)
    )
  }

  final override XXEFlowState transform(XXEFlowState flowstate) {
    exists(int createEntityReferenceNodes |
      encodeXercesFlowState(flowstate, _, createEntityReferenceNodes) and
      (
        newValue.getValue().toInt() = 1 and // true
        encodeXercesFlowState(result, 1, createEntityReferenceNodes)
        or
        not newValue.getValue().toInt() = 1 and // false or unknown
        encodeXercesFlowState(result, 0, createEntityReferenceNodes)
      )
    )
  }
}

/**
 * A flow state transformer for a call to
 * `AbstractDOMParser.setCreateEntityReferenceNodes`. Transforms the flow
 * state through the qualifier according to the setting in the parameter.
 */
class CreateEntityReferenceNodesTranformer extends XXEFlowStateTranformer {
  Expr newValue;

  CreateEntityReferenceNodesTranformer() {
    exists(Call call, Function f |
      call.getTarget() = f and
      f.getDeclaringType() instanceof AbstractDOMParserClass and
      f.hasName("setCreateEntityReferenceNodes") and
      this = call.getQualifier() and
      newValue = call.getArgument(0)
    )
  }

  final override XXEFlowState transform(XXEFlowState flowstate) {
    exists(int disabledDefaultEntityResolution |
      encodeXercesFlowState(flowstate, disabledDefaultEntityResolution, _) and
      (
        newValue.getValue().toInt() = 1 and // true
        encodeXercesFlowState(result, disabledDefaultEntityResolution, 1)
        or
        not newValue.getValue().toInt() = 1 and // false or unknown
        encodeXercesFlowState(result, disabledDefaultEntityResolution, 0)
      )
    )
  }
}

/**
 * The `AbstractDOMParser.parse` or `SAXParser.parse` method.
 */
class ParseFunction extends Function {
  ParseFunction() {
    this.getClassAndName("parse") instanceof AbstractDOMParserClass or
    this.getClassAndName("parse") instanceof SAXParser
  }
}

/**
 * The `createLSParser` function that returns a newly created `DOMLSParser`
 * object.
 */
class CreateLSParser extends Function {
  CreateLSParser() {
    this.hasName("createLSParser") and
    this.getUnspecifiedType().(PointerType).getBaseType().getName() = "DOMLSParser" // returns a `DOMLSParser *`.
  }
}

/**
 * A configuration for tracking XML objects and their states.
 */
class XXEConfiguration extends DataFlow::Configuration {
  XXEConfiguration() { this = "XXEConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    // source is the write on `this` of a call to the `XercesDOMParser`
    // constructor.
    exists(CallInstruction call |
      call.getStaticCallTarget() = any(XercesDOMParserClass c).getAConstructor() and
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
        call.getThisArgument() and
      encodeXercesFlowState(flowstate, 0, 1) // default configuration
    )
    or
    // source is the result of a call to `createLSParser`.
    exists(Call call |
      call.getTarget() instanceof CreateLSParser and
      call = node.asExpr() and
      encodeXercesFlowState(flowstate, 0, 1) // default configuration
    )
    or
    // source is the write on `this` of a call to the `SAXParser`
    // constructor.
    exists(CallInstruction call |
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
        call.getThisArgument() and
      call.getStaticCallTarget().(Constructor).getDeclaringType() instanceof SAXParser and
      encodeXercesFlowState(flowstate, 0, 1) // default configuration
    )
  }

  override predicate isSink(DataFlow::Node node, string flowstate) {
    // sink is the read of the qualifier of a call to `parse`.
    exists(Call call |
      call.getTarget() instanceof ParseFunction and
      call.getQualifier() = node.asConvertedExpr()
    ) and
    flowstate instanceof XercesFlowState and
    not encodeXercesFlowState(flowstate, 1, 1) // safe configuration
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, string state1, DataFlow::Node node2, string state2
  ) {
    // create additional flow steps for `XXEFlowStateTranformer`s
    state2 = node2.asConvertedExpr().(XXEFlowStateTranformer).transform(state1) and
    DataFlow::simpleLocalFlowStep(node1, node2)
  }

  override predicate isBarrier(DataFlow::Node node, string flowstate) {
    // when the flowstate is transformed at a call node, block the original
    // flowstate value.
    node.asConvertedExpr().(XXEFlowStateTranformer).transform(flowstate) != flowstate
  }
}

from XXEConfiguration conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink,
  "This $@ is not configured to prevent an XML external entity (XXE) attack.", source, "XML parser"
