import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

import UUIDLiteral

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(UUIDLiteralMacros)
import UUIDLiteralMacros
#endif

@Test
func instantiate() throws {
    _ = #uuid("18dd849a-1376-4764-9b17-5f4d7f999ac4")
}

@Test
func expand() throws {
    #if canImport(UUIDLiteralMacros)
    assertMacroExpansion(
        """
        #uuid("18dd849a-1376-4764-9b17-5f4d7f999ac4")
        """,
        expandedSource: """
        UUID(uuidString: "18dd849a-1376-4764-9b17-5f4d7f999ac4")!
        """,
        macros: ["uuid": UUIDLiteralMacro.self]
    )
    #else
    throw Skip("macros are only supported when running tests for the host platform")
    #endif
}

@Test
func failWithoutStringLiteral() throws {
    #if canImport(UUIDLiteralMacros)
    assertMacroExpansion(
        """
        let idString = "18dd849a-1376-4764-9b17-5f4d7f999ac4"
        #uuid(idString)
        """,
        expandedSource:
        """
        let idString = "18dd849a-1376-4764-9b17-5f4d7f999ac4"
        #uuid(idString)
        """,
        diagnostics: [
            DiagnosticSpec(
                message: UUIDLiteralError.notAStringLiteral.description,
                line: 2,
                column: 1
            )
        ],
        macros: ["uuid": UUIDLiteralMacro.self]
    )
    #else
    throw Skip("macros are only supported when running tests for the host platform")
    #endif
}

@Test
func failInvalidUUID() throws {
    #if canImport(UUIDLiteralMacros)
    assertMacroExpansion(
    """
        #uuid("not-a-valid-uuid")
        """,
        expandedSource:
        """
        #uuid("not-a-valid-uuid")
        """,
        diagnostics: [
            DiagnosticSpec(
                message: UUIDLiteralError.invalidUUID.description,
                line: 1,
                column: 1
            )
        ],
        macros: ["uuid": UUIDLiteralMacro.self]
    )
    #else
    throw Skip("macros are only supported when running tests for the host platform")
    #endif
}
