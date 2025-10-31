//
//  ReadmeVerificationTests.swift
//  swift-html-prism
//
//  Created to verify all README code examples compile and work correctly
//

import Dependencies
import HTML
import HTMLPrism
import Testing

@Suite("README Verification")
struct ReadmeVerificationTests {

  @Test("Quick Start - Basic Usage (lines 47-64)")
  func quickStartBasicUsage() throws {
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

    let headHtml = try String(head)
    #expect(headHtml.contains("prism"))

    let codeHtml = try String(codeBlock)
    #expect(codeHtml.contains("language-swift"))
    #expect(codeHtml.contains("struct Greeting"))
  }

  @Test("Pre-configured Setups (lines 68-80)")
  func preConfiguredSetups() throws {
    // Minimal setup with basic web languages
    let minimal = Prism.Head.minimal

    // Standard setup with common languages and plugins
    let standard = Prism.Head.standard

    // Full setup with many languages and plugins
    let full = Prism.Head.full

    // Swift-optimized setup
    let swift = Prism.Head.swift

    #expect(try String(minimal).contains("prism"))
    #expect(try String(standard).contains("prism"))
    #expect(try String(full).contains("prism"))
    #expect(try String(swift).contains("prism"))
  }

  @Test("Custom Configuration (lines 87-95)")
  func customConfiguration() throws {
    let config = Prism.Configuration(
      languages: [.swift, .javascript, .python, .rust],
      plugins: [.lineNumbers, .lineHighlight, .copyToClipboard, .toolbar],
      theme: .builtin(.okaidia),
      cdnVersion: "1.29.0"
    )

    let head = Prism.Head(configuration: config)

    let html = try String(head)
    #expect(html.contains("prism-okaidia"))
    #expect(html.contains("prism-swift.min.js"))
    #expect(html.contains("prism-javascript.min.js"))
  }

  @Test("Basic Code Block with Line Numbers (lines 101-106)")
  func basicCodeBlockWithLineNumbers() throws {
    let codeBlock = Prism.CodeBlock(
      language: .javascript,
      lineNumbers: true
    ) {
      "console.log('Hello, World!');"
    }

    let html = try String(codeBlock)
    #expect(html.contains("language-javascript"))
    #expect(html.contains("line-numbers"))
    #expect(html.contains("console.log"))
  }

  @Test("Code Block with Line Highlighting (lines 108-116)")
  func codeBlockWithLineHighlighting() throws {
    let swiftCode = "let x = 1\nlet y = 2\nlet z = 3"

    let codeBlock = Prism.CodeBlock(
      language: .swift,
      lineNumbers: true,
      highlightLines: [3, 5, 7],
      startingLineNumber: 10
    ) {
      swiftCode
    }

    let html = try String(codeBlock)
    #expect(html.contains("language-swift"))
    #expect(html.contains("line-numbers"))
  }

  @Test("Code Block with Title (lines 118-124)")
  func codeBlockWithTitle() throws {
    let pythonCode = "print('Hello')"

    let codeBlock = Prism.CodeBlock(
      language: .python,
      title: "example.py"
    ) {
      pythonCode
    }

    let html = try String(codeBlock)
    #expect(html.contains("example.py"))
    #expect(html.contains("code-block-title"))
  }

  @Test("Command Line with Output Markers (lines 126-137)")
  func commandLineWithOutputMarkers() throws {
    let codeBlock = Prism.CodeBlock.bash(
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

    let html = try String(codeBlock)
    #expect(html.contains("language-bash"))
    #expect(html.contains("npm install"))
  }

  @Test("Inline Code (lines 143-150)")
  func inlineCode() throws {
    let inlineCode = Prism.InlineCode.swift { "print()" }

    // Simulate usage in p tag
    let html = try String(inlineCode)
    #expect(html.contains("language-swift"))
    #expect(html.contains("print()"))
  }

  @Test("Language-specific Conveniences (lines 155-162)")
  func languageSpecificConveniences() throws {
    let swiftCode = "let x = 1"
    let jsCode = "const x = 1"
    let htmlCode = "<div></div>"
    let cssCode = "body { margin: 0; }"
    let shellScript = "#!/bin/bash"
    let diffOutput = "+ added line"
    let jsonData = "{\"key\": \"value\"}"

    let swiftBlock = Prism.CodeBlock.swift { swiftCode }
    let jsBlock = Prism.CodeBlock.javascript { jsCode }
    let htmlBlock = Prism.CodeBlock.html { htmlCode }
    let cssBlock = Prism.CodeBlock.css { cssCode }
    let bashBlock = Prism.CodeBlock.bash(user: "admin", host: "server") { shellScript }
    let diffBlock = Prism.CodeBlock.diff { diffOutput }
    let jsonBlock = Prism.CodeBlock.json { jsonData }

    #expect(try String(swiftBlock).contains("language-swift"))
    #expect(try String(jsBlock).contains("language-javascript"))
    #expect(try String(htmlBlock).contains("language-html"))
    #expect(try String(cssBlock).contains("language-css"))
    #expect(try String(bashBlock).contains("language-bash"))
    #expect(try String(diffBlock).contains("language-diff"))
    #expect(try String(jsonBlock).contains("language-json"))
  }

  @Test("Inline Code Conveniences (lines 164-166)")
  func inlineCodeConveniences() throws {
    let swiftInline = Prism.InlineCode.swift { "let x = 42" }
    let jsInline = Prism.InlineCode.javascript { "const x = 42;" }

    #expect(try String(swiftInline).contains("language-swift"))
    #expect(try String(jsInline).contains("language-javascript"))
  }

  @Test("Language Access (lines 174-190)")
  func languageAccess() {
    // Web languages
    _ = Prism.Language.html
    _ = Prism.Language.css
    _ = Prism.Language.javascript
    _ = Prism.Language.typescript

    // System languages
    _ = Prism.Language.rust
    _ = Prism.Language.go
    _ = Prism.Language.zig
    _ = Prism.Language.c

    // Mobile languages
    _ = Prism.Language.swift
    _ = Prism.Language.kotlin
    _ = Prism.Language.objectivec

    #expect(Prism.Language.swift.className == "language-swift")
  }

  @Test("Language Groups (lines 197-202)")
  func languageGroups() {
    let webLanguages = Prism.Language.webLanguages
    let systemLanguages = Prism.Language.systemLanguages
    let mobileLanguages = Prism.Language.mobileLanguages
    let scriptingLanguages = Prism.Language.scriptingLanguages
    let dataLanguages = Prism.Language.dataLanguages

    #expect(webLanguages.contains(.html))
    #expect(systemLanguages.contains(.rust))
    #expect(mobileLanguages.contains(.swift))
    #expect(scriptingLanguages.contains(.python))
    #expect(dataLanguages.contains(.json))
  }

  @Test("Plugin Configuration (lines 208-221)")
  func pluginConfiguration() {
    _ = Prism.Plugin.lineNumbers
    _ = Prism.Plugin.lineHighlight
    _ = Prism.Plugin.copyToClipboard
    _ = Prism.Plugin.showInvisibles
    _ = Prism.Plugin.toolbar
    _ = Prism.Plugin.matchBraces
    _ = Prism.Plugin.diffHighlight
    _ = Prism.Plugin.commandLine

    let config = Prism.Configuration(
      plugins: [.lineNumbers, .copyToClipboard, .toolbar]
    )

    #expect(config.plugins.count == 3)
  }

  @Test("Built-in Themes (lines 228-236)")
  func builtinThemes() {
    _ = Prism.Theme.default
    _ = Prism.Theme.dark
    _ = Prism.Theme.funky
    _ = Prism.Theme.okaidia
    _ = Prism.Theme.twilight
    _ = Prism.Theme.coy
    _ = Prism.Theme.solarizedlight
    _ = Prism.Theme.tomorrow

    #expect(Prism.Theme.okaidia.rawValue == "prism-okaidia")
  }

  @Test("Custom Theme Builder (lines 242-258)")
  func customThemeBuilder() {
    var builder = Prism.ThemeBuilder()

    builder.setTokenStyle(
      .keyword,
      style: Prism.TokenStyle(
        color: HTMLColor(light: .hex("#AD3DA4"), dark: .hex("#FF79B2"))
      )
    )

    builder.setTokenStyle(
      .string,
      style: Prism.TokenStyle(
        color: HTMLColor(light: .hex("#D22E1B"), dark: .hex("#FF8170"))
      )
    )

    let customTheme = builder.build(name: "my-theme")

    let config = Prism.Configuration(
      theme: .custom(customTheme)
    )

    #expect(customTheme.name == "my-theme")

    switch config.theme {
    case .custom(let theme):
      #expect(theme.name == "my-theme")
    default:
      Issue.record("Expected custom theme")
    }
  }

  @Test("Dependency Injection (lines 280-288)")
  func dependencyInjection() throws {
    withDependencies {
      $0.prismConfiguration = .swift
    } operation: {
      // Prism.Head() will use the Swift configuration
      let head = Prism.Head()

      let html = try? String(head)
      #expect(html != nil)
      #expect(html?.contains("prism") == true)
    }
  }

  @Test("Custom Scripts (lines 293-301)")
  func customScripts() throws {
    let config = Prism.Configuration(
      customScripts: """
        Prism.hooks.add('complete', function(env) {
            console.log('Highlighted:', env.element);
        });
        """
    )

    let head = Prism.Head(configuration: config)
    let html = try String(head)

    #expect(html.contains("Prism.hooks.add"))
    #expect(html.contains("complete"))
  }

  @Test("Custom Styles (lines 306-316)")
  func customStyles() throws {
    let config = Prism.Configuration(
      customStyles: """
        pre[class*="language-"] {
            border-radius: 8px;
            margin: 1rem 0;
        }
        """
    )

    let head = Prism.Head(configuration: config)
    let html = try String(head)

    #expect(html.contains("border-radius: 8px"))
  }
}
