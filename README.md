# UUIDLiteral

`UUIDLiteral` is a Swift macro that provides a compile-time-validated UUID literal.

## Example

```swift
import UUIDLiteral

let uuid = #uuid("18dd849a-1376-4764-9b17-5f4d7f999ac4")
```

## Benefits

If the argument is not a single static string literal, or if the string is not a valid UUID, the macro produces a compile-time error. This eliminates the need for verbose runtime checks or force-unwrapping, which risks crashing at runtime.

```swift
// We already know this is a valid UUID and shouldn't have to check like this
if let uuid = UUID(uuidString: "18dd849a-1376-4764-9b17-5f4d7f999ac4") {
    // Use `uuid`
}

// But if we force-unwrap, there's a risk of a runtime crash if there's a typo
let uuid = UUID(uuidString: "not-a-valid-uuid")! // Crash!!

// With `UUIDLiteral`, this fails at compile time instead
let uuid = #uuid("not-a-valid-uuid") // Error: Invalid UUID
```
