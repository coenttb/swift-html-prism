//
//  File.swift
//  swift-html-prism
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2025.
//

#if canImport(SwiftUI)
  import SwiftUI
  import HTML

  #Preview {
    HTMLDocument {
      Prism.InlineCode.swift {
        """
        let x: String = ""
        """
      }
    } head: {
      Prism.Head.swift
    }
  }

  #Preview {
    HTMLDocument {
      Prism.CodeBlock(
        language: .javascript,
        lineNumbers: true,
        highlightLines: [2, 3]
      ) {
        """
        function fibonacci(n) {
            if (n <= 1) return n;
            return fibonacci(n - 1) + fibonacci(n - 2);
        }
        """
      }
    } head: {
      Prism.Head(
        configuration: .init(
          languages: [.swift, .javascript, .html],
          plugins: [.lineHighlight, .lineNumbers],
          theme: .builtin(.default),
          autoHighlight: true,
          customStyles: nil,
          customScripts: nil
        )
      )
    }
  }

#endif
