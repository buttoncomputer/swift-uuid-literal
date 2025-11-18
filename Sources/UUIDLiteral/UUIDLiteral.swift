@_exported import Foundation

@freestanding(expression)
public macro uuid(_: StaticString) -> UUID = #externalMacro(
    module: "UUIDLiteralMacros",
    type: "UUIDLiteralMacro"
)
