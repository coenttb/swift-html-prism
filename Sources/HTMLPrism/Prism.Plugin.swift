//
//  Prism.Plugin.swift
//  swift-html-prism
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2025.
//

import Foundation

extension Prism {
  public struct Plugin: Sendable {
    public let name: String
    public let fileName: String
    public let cssFileName: String?
    public let configuration: Configuration?

    public init(
      name: String,
      fileName: String,
      cssFileName: String? = nil,
      configuration: Configuration? = nil
    ) {
      self.name = name
      self.fileName = fileName
      self.cssFileName = cssFileName
      self.configuration = configuration
    }

    public struct Configuration: Sendable {
      public let scriptContent: String?

      public init(scriptContent: String? = nil) {
        self.scriptContent = scriptContent
      }
    }

    public func scriptURL(cdnVersion: String) -> String {
      "https://cdnjs.cloudflare.com/ajax/libs/prism/\(cdnVersion)/plugins/\(name.lowercased().replacingOccurrences(of: " ", with: "-"))/\(fileName)"
    }

    public func cssURL(cdnVersion: String) -> String? {
      guard let cssFileName = cssFileName else { return nil }
      return
        "https://cdnjs.cloudflare.com/ajax/libs/prism/\(cdnVersion)/plugins/\(name.lowercased().replacingOccurrences(of: " ", with: "-"))/\(cssFileName)"
    }
  }
}

// Common PrismJS plugins
extension Prism.Plugin {
  public static let lineHighlight = Self(
    name: "Line Highlight",
    fileName: "prism-line-highlight.min.js",
    cssFileName: "prism-line-highlight.min.css"
  )

  public static let lineNumbers = Self(
    name: "Line Numbers",
    fileName: "prism-line-numbers.min.js",
    cssFileName: "prism-line-numbers.min.css"
  )

  public static let copyToClipboard = Self(
    name: "Copy to Clipboard",
    fileName: "prism-copy-to-clipboard.min.js"
  )

  public static let showInvisibles = Self(
    name: "Show Invisibles",
    fileName: "prism-show-invisibles.min.js",
    cssFileName: "prism-show-invisibles.min.css"
  )

  public static let autoloader = Self(
    name: "Autoloader",
    fileName: "prism-autoloader.min.js"
  )

  public static let toolbar = Self(
    name: "Toolbar",
    fileName: "prism-toolbar.min.js",
    cssFileName: "prism-toolbar.min.css"
  )

  public static let matchBraces = Self(
    name: "Match Braces",
    fileName: "prism-match-braces.min.js",
    cssFileName: "prism-match-braces.min.css"
  )

  public static let highlightKeywords = Self(
    name: "Highlight Keywords",
    fileName: "prism-highlight-keywords.min.js"
  )

  public static let inlineColor = Self(
    name: "Inline Color",
    fileName: "prism-inline-color.min.js",
    cssFileName: "prism-inline-color.min.css"
  )

  public static let previewers = Self(
    name: "Previewers",
    fileName: "prism-previewers.min.js",
    cssFileName: "prism-previewers.min.css"
  )

  public static let commandLine = Self(
    name: "Command Line",
    fileName: "prism-command-line.min.js",
    cssFileName: "prism-command-line.min.css"
  )

  public static let unescapedMarkup = Self(
    name: "Unescaped Markup",
    fileName: "prism-unescaped-markup.min.js",
    cssFileName: "prism-unescaped-markup.min.css"
  )

  public static let normalizeWhitespace = Self(
    name: "Normalize Whitespace",
    fileName: "prism-normalize-whitespace.min.js"
  )

  public static let dataUriHighlight = Self(
    name: "Data-URI Highlight",
    fileName: "prism-data-uri-highlight.min.js"
  )

  public static let diffHighlight = Self(
    name: "Diff Highlight",
    fileName: "prism-diff-highlight.min.js",
    cssFileName: "prism-diff-highlight.min.css"
  )

  public static let jsonp = Self(
    name: "JSONP Highlight",
    fileName: "prism-jsonp-highlight.min.js"
  )

  public static let wpd = Self(
    name: "WebPlatform Docs",
    fileName: "prism-wpd.min.js",
    cssFileName: "prism-wpd.min.css"
  )

  public static let customClass = Self(
    name: "Custom Class",
    fileName: "prism-custom-class.min.js"
  )

  public static let fileHighlight = Self(
    name: "File Highlight",
    fileName: "prism-file-highlight.min.js"
  )

  public static let showLanguage = Self(
    name: "Show Language",
    fileName: "prism-show-language.min.js"
  )

  public static let treeview = Self(
    name: "Treeview",
    fileName: "prism-treeview.min.js",
    cssFileName: "prism-treeview.min.css"
  )
}
