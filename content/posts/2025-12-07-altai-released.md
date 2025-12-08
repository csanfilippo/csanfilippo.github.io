+++
date = 2025-12-06T11:11:24+01:00
draft = false
title = "altai: elevating typed throws in Swift"
description = "altai: elevating typed throws in Swift"
slug = "altai-released"
authors = ["Calogero Sanfilippo"]
tags = ["altai", "swift"]
+++

[Swift 6](https://www.swift.org/blog/announcing-swift-6/) introduced *typed throws*, a powerful enhancement that allows developers to declare the specific error types a function may throw. While this feature improves clarity and safety, it also introduces challenges, particularly when dealing with nested or heterogeneous error sources. 

**altai**, a lightweight Swift package, addresses these pain points by offering a clean, idiomatic way to uplift and unify errors without verbose boilerplate.

## The problem with typed throws

Typed throws enable functions to specify error types directly in their signatures:

```swift
enum CustomError: Error {
    case oddNumber
    case decodingError
}

func throwingIfOdd(_ number: String) throws(CustomError) -> Int {
    
    do {
        let number = try JSONDecoder().decode(Int.self, from: number.data(using: .utf8)!)
        
        guard isEven(number) else {
            throw CustomError.oddNumber
        }
        
        return number
    } catch {
        if let customError = error as? CustomError {
            throw customError
        } else {
            throw .decodingError
        }
    }
}
```

This improves compiler awareness and type safety. However, when functions interact with other APIs—such as `JSONDecoder`—developers often face the burden of catching, mapping, and rethrowing errors manually. This leads to repetitive code and obscures intent.

## altai's approach

Altai introduces the `UpliftingErrors` protocol, allowing custom error enums to “uplift” foreign errors seamlessly:

```swift
enum CustomError: Error, UpliftingErrors {
    case oddNumber
    case uplifted(any Error)
}

func throwingIfOdd(_ number: String) throws(CustomError) -> Int {
    let number = try CustomError.uplift {
        try JSONDecoder().decode(Int.self, from: number.data(using: .utf8)!)
    }
    guard number % 2 == 0 else { throw .oddNumber }
    return number
}
```

Here, any error thrown by `JSONDecoder` is automatically uplifted into CustomError, eliminating the need for verbose catch-and-map logic. The result is cleaner, more maintainable code that preserves type safety while reducing friction.

## Integration with Swift Package Manager

altai is distributed via Swift Package Manager and can be added to any project with a single dependency declaration:

```swift
dependencies: [
    .package(url: "https://github.com/csanfilippo/altai.git", from: "1.0.0")
]
```

## Learn more

- Full documentation and usage examples are on [GitHub](https://github.com/csanfilippo/altai)
- altai is index by [Swift Package Index](https://swiftpackageindex.com/csanfilippo/altai)