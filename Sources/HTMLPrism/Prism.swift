//
//  Prism.swift
//  swift-html-prism
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2025.
//

import Foundation
import HTML
import HTMLTheme
import Dependencies
import Builders

public enum Prism {
    // MARK: - Configuration
    
    public struct Configuration: Sendable {
        public let languages: [Language]
        public let plugins: [Plugin]
        public let theme: ThemeOption
        public let cdnVersion: String
        public let autoHighlight: Bool
        public let customStyles: String?
        public let customScripts: String?
        
        public init(
            languages: [Language] = [],
            plugins: [Plugin] = [],
            theme: ThemeOption = .builtin(.default),
            cdnVersion: String = "1.29.0",
            autoHighlight: Bool = true,
            customStyles: String? = nil,
            customScripts: String? = nil
        ) {
            self.languages = languages
            self.plugins = plugins
            self.theme = theme
            self.cdnVersion = cdnVersion
            self.autoHighlight = autoHighlight
            self.customStyles = customStyles
            self.customScripts = customScripts
        }
        
        public enum ThemeOption: Sendable {
            case builtin(Theme)
            case custom(CustomTheme)
            case none
        }
    }
    
    // MARK: - Head Component
    
    public struct Head: HTML {
        private let configuration: Configuration
        
        public init(configuration: Configuration? = nil) {
            @Dependency(\.prismConfiguration) var defaultConfig
            self.configuration = configuration ?? defaultConfig
        }
        
        @HTMLBuilder
        public var body: some HTML {
            // Theme CSS
            switch configuration.theme {
            case .builtin(let theme):
                link(
                    href: .init(theme.cssURL(cdnVersion: configuration.cdnVersion)),
                    rel: "stylesheet"
                )
            case .custom(let customTheme):
                Style {
                    customTheme.styles
                }
            case .none:
                HTMLText("<!-- No theme -->")
            }
            
            // Plugin CSS files
            HTMLForEach(configuration.plugins) { plugin in
                if let cssURL = plugin.cssURL(cdnVersion: configuration.cdnVersion) {
                    link(
                        href: .init(cssURL),
                        rel: "stylesheet"
                    )
                }
            }
            
            // Additional styles
            Style {
                Self.defaultStyles
                
                if configuration.plugins.contains(where: { $0.name == "Line Highlight" }) {
                    Self.lineHighlightStyles
                }
                
                if configuration.languages.contains(.diff) {
                    Self.diffStyles
                }
                
                if configuration.languages.contains(.swift) {
                    Self.swiftStyles
                }
                
                if let customStyles = configuration.customStyles {
                    customStyles
                }
            }
            
            // Core Prism script
            script(
                src: .init("https://cdnjs.cloudflare.com/ajax/libs/prism/\(configuration.cdnVersion)/prism.min.js"),
                defer: true
            )()
            
            // Plugin scripts
            HTMLForEach(configuration.plugins) { plugin in
                script(
                    src: .init(plugin.scriptURL(cdnVersion: configuration.cdnVersion)),
                    defer: true
                )()
            }
            
            // Language scripts
            HTMLForEach(configuration.languages) { language in
                script(
                    src: .init("https://cdnjs.cloudflare.com/ajax/libs/prism/\(configuration.cdnVersion)/components/\(language.cdnComponentPath)"),
                    defer: true
                )()
            }
            
            // Custom scripts including Swift enhancements
            script {
                buildInitializationScript()
            }
        }
        
        private func buildInitializationScript() -> String {
            var script = """
            document.addEventListener("DOMContentLoaded", function () {
              if (typeof Prism !== "undefined") {
                \(configuration.autoHighlight ? "Prism.highlightAll();" : "")
            """
            
            if configuration.languages.contains(.swift) {
                script += Self.swiftEnhancements
            }
            
            if let customScripts = configuration.customScripts {
                script += "\n" + customScripts
            }
            
            script += """
              }
            });
            """
            
            return script
        }
        
        private static var defaultStyles: String {
            """
            pre {
              position: relative;
              overflow-x: auto;
            }
            
            code[class*="language-"],
            pre[class*="language-"] {
              font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
              font-size: 14px;
              line-height: 1.5;
            }
            """
        }
        
        private static var lineHighlightStyles: String {
            """
            .line-highlight {
              background-color: rgba(0, 121, 255, 0.1);
              margin-top: 1rem;
              margin-left: -1.5rem;
              position: absolute;
            }
            
            .highlight-pass .line-highlight {
              background-color: rgba(0, 255, 50, 0.15);
            }
            
            .highlight-fail .line-highlight {
              background-color: rgba(255, 68, 68, 0.15);
            }
            
            .highlight-warn .line-highlight {
              background-color: rgba(254, 223, 43, 0.15);
            }
            
            @media (prefers-color-scheme: dark) {
              .line-highlight {
                background-color: rgba(255, 255, 255, 0.1);
              }
            }
            """
        }
        
        private static var diffStyles: String {
            """
            .language-diff {
              color: #808080;
            }
            
            .language-diff .token.inserted {
              background-color: #f0fff4;
              color: #22863a;
              margin: -4px;
              padding: 4px;
            }
            
            .language-diff .token.deleted {
              background-color: #ffeef0;
              color: #b31d28;
              margin: -3px;
              padding: 3px;
            }
            
            @media (prefers-color-scheme: dark) {
              .language-diff .token.inserted {
                background-color: #071c06;
                color: #6fd574;
              }
              
              .language-diff .token.deleted {
                background-color: #280c0f;
                color: #f95258;
              }
            }
            """
        }
        
        private static var swiftStyles: String {
            """
            .token.placeholder, .token.code-fold {
              background-color: #bbb;
              border-radius: 6px;
              color: #fff;
              margin: -2px;
              padding: 2px;
            }
            
            .token.placeholder-open,
            .token.placeholder-close {
              display: none;
            }
            
            .token.todo {
              font-weight: 700;
            }
            
            @media (prefers-color-scheme: dark) {
              .token.placeholder, .token.code-fold {
                background-color: #87878A;
              }
            }
            """
        }
        
        private static var swiftEnhancements: String {
            """
                // Enhanced Swift class name detection
                if (Prism.languages.swift) {
                  Prism.languages.swift['class-name'] = [
                    /\\b(_[A-Z]\\w*)\\b/,
                    Prism.languages.swift['class-name']
                  ];
                  
                  // Additional Swift keywords
                  Prism.languages.swift.keyword = [
                    /\\b(any|macro)\\b/,
                    /\\b((iOS|macOS|tvOS|watchOS|visionOS)(|ApplicationExtension)|swift)\\b/,
                    Prism.languages.swift.keyword
                  ];
                  
                  // TODO comment highlighting
                  Prism.languages.swift.comment.inside = {
                    todo: {
                      pattern: /(TODO:)/
                    }
                  };
                  
                  // Code folding indicator
                  Prism.languages.insertBefore('swift', 'operator', {
                    'code-fold': {
                      pattern: /…/
                    },
                  });
                  
                  // Xcode placeholders
                  Prism.languages.insertBefore('swift', 'string-literal', {
                    'placeholder': {
                      pattern: /<#.+?#>/,
                      inside: {
                        'placeholder-open': {
                          pattern: /<#/
                        },
                        'placeholder-close': {
                          pattern: /#>/
                        },
                      }
                    },
                  });
                }
            """
        }
    }
    
    // MARK: - CodeBlock Component
    
    public struct CodeBlock: HTML {
        private let language: Language?
        private let lineNumbers: Bool
        private let highlightLines: [Int]
        private let startingLineNumber: Int
        private let title: String?
        private let commandLine: CommandLineOptions?
        private let codeContent: String
        
        public init(
            language: Language? = nil,
            lineNumbers: Bool = false,
            highlightLines: [Int] = [],
            startingLineNumber: Int = 1,
            title: String? = nil,
            commandLine: CommandLineOptions? = nil,
            @StringBuilder _ code: () -> String
        ) {
            self.codeContent = code()
            self.language = language
            self.lineNumbers = lineNumbers
            self.highlightLines = highlightLines
            self.startingLineNumber = startingLineNumber
            self.title = title
            self.commandLine = commandLine
        }
        
        @HTMLBuilder
        public var body: some HTML {
            if let title = title {
                div {
                    div {
                        HTMLText(title)
                    }
                    .class("code-block-title")
                    codeBlockContent
                }
                .class("code-block-wrapper")
            } else {
                codeBlockContent
            }
        }
        
        @HTMLBuilder
        private var codeBlockContent: some HTML {
            let baseClass: Class? = lineNumbers ? "line-numbers" : nil
            let attrs = buildDataAttributes()
            
            pre {
                code {
                    HTMLText(codeContent)
                }
                .class(.init(language?.className ?? "language-none"))
            }
            .class(baseClass)
            .attribute(attrs)
        }
        
        private func buildDataAttributes() -> String {
            var attrs: [String] = []
            
            if !highlightLines.isEmpty {
                let lines = highlightLines.map(String.init).joined(separator: ",")
                attrs.append("data-line=\"\(lines)\"")
            }
            
            if startingLineNumber != 1 {
                attrs.append("data-start=\"\(startingLineNumber)\"")
            }
            
            if let cmdOptions = commandLine {
                if let user = cmdOptions.user {
                    attrs.append("data-user=\"\(user)\"")
                }
                if let host = cmdOptions.host {
                    attrs.append("data-host=\"\(host)\"")
                }
                if !cmdOptions.outputLines.isEmpty {
                    let output = cmdOptions.outputLines.map(String.init).joined(separator: ",")
                    attrs.append("data-output=\"\(output)\"")
                }
                if let prompt = cmdOptions.prompt {
                    attrs.append("data-prompt=\"\(prompt)\"")
                }
            }
            
            return attrs.joined(separator: " ")
        }
        
        public struct CommandLineOptions: Sendable {
            public let user: String?
            public let host: String?
            public let outputLines: [Int]
            public let prompt: String?
            
            public init(
                user: String? = nil,
                host: String? = nil,
                outputLines: [Int] = [],
                prompt: String? = nil
            ) {
                self.user = user
                self.host = host
                self.outputLines = outputLines
                self.prompt = prompt
            }
        }
    }
    
    // MARK: - InlineCode Component
    
    public struct InlineCode: HTML {
        private let language: Prism.Language?
        private let codeContent: String
        
        public init(
            language: Prism.Language? = nil,
            @StringBuilder _ code: () -> String
        ) {
            self.codeContent = code()
            self.language = language
        }
        
        @HTMLBuilder
        public var body: some HTML {
            code {
                HTMLText(codeContent)
            }
            .class("\(language?.className ?? "language-none")")
        }
    }
}

// MARK: - Convenience Extensions

extension Prism.Head {
    public static var minimal: Self {
        Self(configuration: .minimal)
    }
    
    public static var standard: Self {
        Self(configuration: .standard)
    }
    
    public static var full: Self {
        Self(configuration: .full)
    }
    
    public static var swift: Self {
        Self(configuration: .swift)
    }
}

extension Prism.Configuration {
    public static let minimal = Self(
        languages: [.javascript, .css, .html],
        plugins: [.lineNumbers, .lineHighlight],
        theme: .builtin(.default)
    )
    
    public static let standard = Self(
        languages: Prism.Language.webLanguages + Prism.Language.dataLanguages,
        plugins: [.lineNumbers, .lineHighlight, .copyToClipboard],
        theme: .builtin(.okaidia)
    )
    
    public static let full = Self(
        languages: Prism.Language.webLanguages +
                  Prism.Language.scriptingLanguages +
                  Prism.Language.systemLanguages +
                  Prism.Language.dataLanguages,
        plugins: [
            .lineNumbers,
            .lineHighlight,
            .copyToClipboard,
            .showInvisibles,
            .toolbar,
            .matchBraces
        ],
        theme: .builtin(.okaidia)
    )
    
    public static let swift = Self(
        languages: [.swift] + Prism.Language.webLanguages + Prism.Language.dataLanguages,
        plugins: [
            .lineNumbers,
            .lineHighlight,
            .copyToClipboard,
            .toolbar
        ],
        theme: .custom(.swift)
    )
    
    public static let mobile = Self(
        languages: Prism.Language.mobileLanguages + Prism.Language.dataLanguages,
        plugins: [
            .lineNumbers,
            .copyToClipboard,
            .toolbar
        ],
        theme: .builtin(.tomorrow)
    )
}

extension Prism.CodeBlock {
    public static func swift(
        lineNumbers: Bool = true,
        highlightLines: [Int] = [],
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .swift,
            lineNumbers: lineNumbers,
            highlightLines: highlightLines,
            code
        )
    }
    
    public static func javascript(
        lineNumbers: Bool = true,
        highlightLines: [Int] = [],
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .javascript,
            lineNumbers: lineNumbers,
            highlightLines: highlightLines,
            code
        )
    }
    
    public static func html(
        lineNumbers: Bool = true,
        highlightLines: [Int] = [],
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .html,
            lineNumbers: lineNumbers,
            highlightLines: highlightLines,
            code
        )
    }
    
    public static func css(
        lineNumbers: Bool = true,
        highlightLines: [Int] = [],
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .css,
            lineNumbers: lineNumbers,
            highlightLines: highlightLines,
            code
        )
    }
    
    public static func bash(
        user: String? = nil,
        host: String? = nil,
        outputLines: [Int] = [],
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .bash,
            commandLine: CommandLineOptions(
                user: user,
                host: host,
                outputLines: outputLines
            ),
            code
        )
    }
    
    public static func diff(
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .diff,
            code
        )
    }
    
    public static func json(
        lineNumbers: Bool = false,
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .json,
            lineNumbers: lineNumbers,
            code,
        )
    }
}

extension Prism.InlineCode {
    public static func swift(
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .swift,
            code
        )
    }
    
    public static func javascript(
        @StringBuilder _ code: () -> String
    ) -> Self {
        Self(
            language: .javascript,
            code
        )
    }
}

// MARK: - Dependency Support

extension Prism.Configuration: DependencyKey {
    public static var liveValue: Self { .standard }
    public static var testValue: Self { .minimal }
    public static var previewValue: Self { .standard }
}

extension DependencyValues {
    public var prismConfiguration: Prism.Configuration {
        get { self[Prism.Configuration.self] }
        set { self[Prism.Configuration.self] = newValue }
    }
}
