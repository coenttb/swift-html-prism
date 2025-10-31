# swift-html-prism

[![CI](https://github.com/coenttb/swift-html-prism/workflows/CI/badge.svg)](https://github.com/coenttb/swift-html-prism/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A type-safe Swift DSL for PrismJS syntax highlighting, built on swift-html.

## Overview

swift-html-prism provides a strongly-typed Swift interface for integrating PrismJS syntax highlighting into server-side rendered HTML. It uses swift-html's type-safe HTML DSL to generate syntax-highlighted code blocks with compile-time guarantees.

## Features

- Type-safe API with strongly typed languages, plugins, and themes
- Support for 297 PrismJS languages via the Language enum
- Modular plugin system with easy configuration
- Built-in and custom theme support with dark mode
- Swift-specific enhancements (keyword detection, Xcode placeholders, TODO highlighting)
- Integration with swift-dependencies for configuration management
- StringBuilder pattern for ergonomic code block creation

## Installation

Add swift-html-prism to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-html-prism", from: "0.1.0")
]
```

Add the product to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "HTMLPrism", package: "swift-html-prism")
    ]
)
```

## Quick Start

### Basic Usage

```swift
import HTMLPrism
import HTML

// Add PrismJS resources to your HTML head
let head = Prism.Head.swift

// Create a syntax-highlighted code block
let codeBlock = Prism.CodeBlock.swift(
    lineNumbers: true
) {
    """
    struct Greeting {
        let message = "Hello, World!"
    }
    """
}
```

### Pre-configured Setups

```swift
// Minimal setup with basic web languages
Prism.Head.minimal    // HTML, CSS, JavaScript

// Standard setup with common languages and plugins
Prism.Head.standard   // Web + data languages, copy-to-clipboard

// Full setup with many languages and plugins
Prism.Head.full       // Web, scripting, system, data languages

// Swift-optimized setup
Prism.Head.swift      // Swift + web languages, custom Swift theme
```

## Usage Examples

### Custom Configuration

```swift
let config = Prism.Configuration(
    languages: [.swift, .javascript, .python, .rust],
    plugins: [.lineNumbers, .lineHighlight, .copyToClipboard, .toolbar],
    theme: .builtin(.okaidia),
    cdnVersion: "1.29.0"
)

let head = Prism.Head(configuration: config)
```

### Code Blocks with Features

```swift
// Basic code block with line numbers
Prism.CodeBlock(
    language: .javascript,
    lineNumbers: true
) {
    "console.log('Hello, World!');"
}

// Code block with line highlighting
Prism.CodeBlock(
    language: .swift,
    lineNumbers: true,
    highlightLines: [3, 5, 7],
    startingLineNumber: 10
) {
    swiftCode
}

// Code block with title
Prism.CodeBlock(
    language: .python,
    title: "example.py"
) {
    pythonCode
}

// Command line with output markers
Prism.CodeBlock.bash(
    user: "john",
    host: "macbook",
    outputLines: [2, 3]
) {
    """
    $ npm install
    > Installing packages...
    Done!
    """
}
```

### Inline Code

```swift
import HTML

p {
    "The "
    Prism.InlineCode.swift { "print()" }
    " function outputs text to the console."
}
```

### Convenience Methods

```swift
// Language-specific conveniences
Prism.CodeBlock.swift { swiftCode }
Prism.CodeBlock.javascript { jsCode }
Prism.CodeBlock.html { htmlCode }
Prism.CodeBlock.css { cssCode }
Prism.CodeBlock.bash(user: "admin", host: "server") { shellScript }
Prism.CodeBlock.diff { diffOutput }
Prism.CodeBlock.json { jsonData }

// Inline code conveniences
Prism.InlineCode.swift { "let x = 42" }
Prism.InlineCode.javascript { "const x = 42;" }
```

## Languages

Access all 297 PrismJS languages through the type-safe Language enum:

```swift
// Web languages
Prism.Language.html
Prism.Language.css
Prism.Language.javascript
Prism.Language.typescript

// System languages
Prism.Language.rust
Prism.Language.go
Prism.Language.zig
Prism.Language.c

// Mobile languages
Prism.Language.swift
Prism.Language.kotlin
Prism.Language.objectivec
```

### Language Groups

Pre-defined language collections for common use cases:

```swift
Prism.Language.webLanguages       // HTML, CSS, JS, TS, etc.
Prism.Language.systemLanguages    // Rust, Go, Zig, C, C++
Prism.Language.mobileLanguages    // Swift, Kotlin, Java, Objective-C
Prism.Language.scriptingLanguages // Python, Ruby, Perl, PHP
Prism.Language.dataLanguages      // JSON, YAML, XML, TOML
```

## Plugins

Configure PrismJS plugins through the type-safe Plugin enum:

```swift
Prism.Plugin.lineNumbers
Prism.Plugin.lineHighlight
Prism.Plugin.copyToClipboard
Prism.Plugin.showInvisibles
Prism.Plugin.toolbar
Prism.Plugin.matchBraces
Prism.Plugin.diffHighlight
Prism.Plugin.commandLine

let config = Prism.Configuration(
    plugins: [.lineNumbers, .copyToClipboard, .toolbar]
)
```

## Themes

### Built-in Themes

```swift
Prism.Theme.default
Prism.Theme.dark
Prism.Theme.funky
Prism.Theme.okaidia
Prism.Theme.twilight
Prism.Theme.coy
Prism.Theme.solarizedlight
Prism.Theme.tomorrow
```

### Custom Themes

Build custom themes with the ThemeBuilder:

```swift
var builder = Prism.ThemeBuilder()

builder.setTokenStyle(.keyword, style: Prism.TokenStyle(
    color: HTMLColor(light: .hex("#AD3DA4"), dark: .hex("#FF79B2"))
))

builder.setTokenStyle(.string, style: Prism.TokenStyle(
    color: HTMLColor(light: .hex("#D22E1B"), dark: .hex("#FF8170"))
))

let customTheme = builder.build(name: "my-theme")

let config = Prism.Configuration(
    theme: .custom(customTheme)
)
```

## Swift Enhancements

Swift code highlighting includes enhanced features:

- Extended class name detection for Swift naming conventions
- Additional Swift keywords (any, macro, etc.)
- Platform availability keywords (iOS, macOS, tvOS, watchOS, visionOS)
- TODO comment highlighting
- Xcode placeholder support (`<#placeholder#>`)
- Code folding indicator support

These enhancements are automatically included when Swift is in the languages list.

## Advanced Usage

### Dependency Injection

Configure Prism globally using swift-dependencies:

```swift
import Dependencies

withDependencies {
    $0.prismConfiguration = .swift
} operation: {
    // Prism.Head() will use the Swift configuration
    let head = Prism.Head()
}
```

### Custom Scripts

Add custom initialization or hook scripts:

```swift
let config = Prism.Configuration(
    customScripts: """
        Prism.hooks.add('complete', function(env) {
            console.log('Highlighted:', env.element);
        });
        """
)
```

### Custom Styles

Inject additional CSS:

```swift
let config = Prism.Configuration(
    customStyles: """
        pre[class*="language-"] {
            border-radius: 8px;
            margin: 1rem 0;
        }
        """
)
```

## Related Packages

- [swift-html](https://github.com/coenttb/swift-html) - The Swift library for domain-accurate and type-safe HTML & CSS

## License

This package is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome. Please feel free to submit a Pull Request.
