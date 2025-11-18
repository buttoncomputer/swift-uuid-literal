import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum UUIDLiteralError: Error, CustomStringConvertible {
    case notAStringLiteral
    case invalidUUID

    public var description: String {
        switch self {
        case .notAStringLiteral:
            "Not a string literal"
        case .invalidUUID:
            "Invalid UUID"
        }
    }
}

public struct UUIDLiteralMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws(UUIDLiteralError) -> ExprSyntax {
        guard let argument = node.arguments.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
              segments.count == 1,
              case .stringSegment(let literalSegment) = segments.first
        else {
            throw UUIDLiteralError.notAStringLiteral
        }

        let string = literalSegment.content.text
        guard UUID(uuidString: string) != nil else {
            throw UUIDLiteralError.invalidUUID
        }

        return "UUID(uuidString: \(literal: string))!"
    }
}

@main
struct UUIDLiteralPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        UUIDLiteralMacro.self,
    ]
}
