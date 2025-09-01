# swift-html-prism

A type-safe Swift DSL for [PrismJS](https://prismjs.com) syntax highlighting, built on [swift-html](https://github.com/coenttb/swift-html).

## Features

- 🎨 **Type-safe API** - Strongly typed languages, plugins, and themes
- 🌍 **297 Languages** - Support for all PrismJS languages
- 🔌 **Plugin System** - Easy configuration of PrismJS plugins
- 🎭 **Theme Support** - Built-in and custom themes
- 🚀 **Swift Optimized** - Special enhancements for Swift code highlighting
- 📦 **Modular Design** - Use only what you need
- 🌙 **Dark Mode** - Automatic dark mode support

## Installation

Add swift-html-prism to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-html-prism", from: "0.1.0")
]
```

Then add it to your target dependencies:

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

// In your HTML document head
let document = HTMLDocument {
    html {
        head {
            // Add PrismJS resources
            Prism.Head.swift
        }
        body {
            // Add a code block
            Prism.CodeBlock.swift("""
                struct Greeting {
                    let message = "Hello, World!"
                }
                """,
                lineNumbers: true
            )
        }
    }
}
```

### Custom Configuration

```swift
let prismConfig = Prism.Configuration(
    languages: [.swift, .javascript, .python, .rust],
    plugins: [
        .lineNumbers,
        .lineHighlight,
        .copyToClipboard,
        .toolbar
    ],
    theme: .builtin(.okaidia),
    cdnVersion: "1.29.0"
)

Prism.Head(configuration: prismConfig)
```

## Components

### Prism.Head

Generates all necessary `<head>` elements for PrismJS:

```swift
// Pre-configured options
Prism.Head.minimal    // Basic web languages
Prism.Head.standard   // Common languages and plugins
Prism.Head.full       // Many languages and plugins
Prism.Head.swift      // Optimized for Swift development

// Custom configuration
Prism.Head(configuration: myConfig)
```

### Prism.CodeBlock

Create syntax-highlighted code blocks:

```swift
// Basic code block
Prism.CodeBlock(language: .javascript) {
    "console.log('Hello');"
}

// With line numbers and highlighting
Prism.CodeBlock(
    language: .swift,
    lineNumbers: true,
    highlightLines: [3, 5, 7],
    startingLineNumber: 10
) {
    swiftCode
}

// With title
Prism.CodeBlock(
    language: .python,
    title: "example.py"
) {
    sourceCode
}

// Command line with output
Prism.CodeBlock.bash(
    user: "john",
    host: "macbook",
    outputLines: [2, 3]
) {
    """
    $ npm install
    > Installing...
    Done!
    """
}
```

### Prism.InlineCode

For inline code snippets:

```swift
p {
    "The "
    Prism.InlineCode.swift { "print()" }
    " function outputs text."
}
```

## Languages

Access all 297 PrismJS languages through the type-safe `Prism.Language` enum:

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

// Mobile languages
Prism.Language.swift
Prism.Language.kotlin
Prism.Language.objectivec

// And many more...
```

Pre-defined language groups:

```swift
Prism.Language.webLanguages       // HTML, CSS, JS, TS, etc.
Prism.Language.systemLanguages    // Rust, Go, Zig, etc.
Prism.Language.mobileLanguages    // Swift, Kotlin, ObjC, etc.
Prism.Language.scriptingLanguages // Python, Ruby, Perl, etc.
Prism.Language.dataLanguages      // JSON, YAML, XML, etc.
```

## Plugins

Configure PrismJS plugins easily:

```swift
// Available plugins
Prism.Plugin.lineNumbers
Prism.Plugin.lineHighlight
Prism.Plugin.copyToClipboard
Prism.Plugin.showInvisibles
Prism.Plugin.toolbar
Prism.Plugin.matchBraces
Prism.Plugin.diffHighlight
Prism.Plugin.commandLine
// ... and more

let config = Prism.Configuration(
    plugins: [.lineNumbers, .copyToClipboard]
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

This package includes special enhancements for Swift code:

- Enhanced class name detection
- Additional Swift keywords (any, macro, etc.)
- Platform availability keywords (iOS, macOS, etc.)
- TODO comment highlighting
- Xcode placeholder support (`<#placeholder#>`)
- Code folding indicators

These are automatically applied when Swift is included in the languages.

## Advanced Usage

### Dependency Injection

Use with swift-dependencies:

```swift
import Dependencies

// Set global configuration
withDependencies {
    $0.prismConfiguration = .swift
} operation: {
    // Prism.Head will use the Swift configuration
    let head = Prism.Head()
}
```

### Custom Scripts

Add custom initialization scripts:

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

Add additional CSS:

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

## Examples

### Documentation Site

```swift
struct DocPage: HTML {
    let content: String
    
    var body: some HTML {
        HTMLDocument {
            article {
                h1 { "API Reference" }
                
                Prism.CodeBlock(
                    language: .swift,
                    lineNumbers: true,
                    title: "Example.swift"
                ) {
                    content
                }
            }
        } head: {
            title { "Documentation" }
            Prism.Head.standard
        }
    }
}
```

### Blog Post with Multiple Languages

```swift
struct BlogPost: HTML {
    var body: some HTML {
        HTMLDocument {
            article {
                h2 { "Swift Example" }
                Prism.CodeBlock.swift { swiftCode }
                
                h2 { "Python Equivalent" }
                Prism.CodeBlock(
                    language: .python,
                    lineNumbers: true
                ) {
                    pythonCode
                }
                
                h2 { "JavaScript Version" }
                Prism.CodeBlock.javascript { jsCode }
            }
        } head: {
            Prism.Head(configuration: .init(
                languages: [.swift, .python, .javascript],
                plugins: [.copyToClipboard],
                theme: .builtin(.tomorrow)
            ))
        }
    }
}
```

## License

This package is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- [PrismJS](https://prismjs.com) for the excellent syntax highlighting library
- [swift-html](https://github.com/coenttb/swift-html) for the HTML DSL foundation
