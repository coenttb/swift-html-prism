//
//  PrismSnapshotTests.swift
//  swift-html-prism
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2025.
//

import Testing
import HTMLPrism
import HTML
import PointFreeHTMLTestSupport

@Suite(
    "Snapshots",
    .snapshots(record: .failed)
)
struct Snapshots {
    
    @Test("InlineCode Swift Snapshot")
    func inlineCodeSwiftSnapshot() throws {
        let swiftInline = Prism.InlineCode.swift {
            "let result = calculate(x: 10, y: 20)"
        }
        
        assertInlineSnapshot(
            of: HTMLDocument { swiftInline },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body><code class="language-swift">let result = calculate(x: 10, y: 20)</code>
              </body>
            </html>
            """
        }
    }
    
    @Test("InlineCode JavaScript Snapshot")
    func inlineCodeJavaScriptSnapshot() throws {
        let jsInline = Prism.InlineCode.javascript {
            "const result = calculate(10, 20);"
        }
        
        assertInlineSnapshot(
            of: jsInline,
            as: .html
        ) {
        """
        <code class="language-javascript">const result = calculate(10, 20);</code>
        """
        }
    }
    
    @Test("CodeBlock Swift Snapshot")
    func codeBlockSwiftSnapshot() throws {
        let codeBlock = Prism.CodeBlock.swift {
        """
        struct User {
            let name: String
            let age: Int
        }
        """
        }
        
        assertInlineSnapshot(
            of: codeBlock,
            as: .html
        ) {
            """

            <pre class="line-numbers" ><code class="language-swift">struct User {
                let name: String
                let age: Int
            }</code></pre>
            """
        }
    }
    
    @Test("CodeBlock with Line Numbers Snapshot")
    func codeBlockWithLineNumbersSnapshot() throws {
        let codeBlock = Prism.CodeBlock(
            language: .swift,
            lineNumbers: true
        ) {
        """
        func greet(_ name: String) {
            print("Hello, \\(name)!")
        }
        """
        }
        
        assertInlineSnapshot(
            of: codeBlock,
            as: .html
        ) {
            #"""

            <pre class="line-numbers" ><code class="language-swift">func greet(_ name: String) {
                print("Hello, \(name)!")
            }</code></pre>
            """#
        }
    }
    
    @Test("CodeBlock with Title Snapshot")
    func codeBlockWithTitleSnapshot() throws {
        let codeBlock = Prism.CodeBlock(
            language: .swift,
            title: "Greeting.swift"
        ) {
            "print(\"Hello, World!\")"
        }
        
        assertInlineSnapshot(
            of: HTMLDocument { codeBlock },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <div class="code-block-wrapper">
              <div class="code-block-title">Greeting.swift
              </div>
              <pre ><code class="language-swift">print("Hello, World!")</code></pre>
            </div>
              </body>
            </html>
            """
        }
    }
    
    @Test("CodeBlock with Highlighted Lines Snapshot")
    func codeBlockWithHighlightedLinesSnapshot() throws {
        let codeBlock = Prism.CodeBlock(
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
        
        assertInlineSnapshot(
            of: HTMLDocument { codeBlock },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <pre class="line-numbers" data-line="2,3"><code class="language-javascript">function fibonacci(n) {
                if (n &lt;= 1) return n;
                return fibonacci(n - 1) + fibonacci(n - 2);
            }</code></pre>
              </body>
            </html>
            """
        }
    }
    
    @Test("Command Line Block Snapshot")
    func commandLineBlockSnapshot() throws {
        let bashBlock = Prism.CodeBlock.bash(
            user: "admin",
            host: "server",
            outputLines: [2, 3]
        ) {
        """
        $ npm install
        > Installing packages...
        Done!
        """
        }
        
        assertInlineSnapshot(
            of: HTMLDocument { bashBlock },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <pre data-user="admin" data-host="server" data-output="2,3"><code class="language-bash">$ npm install
            &gt; Installing packages...
            Done!</code></pre>
              </body>
            </html>
            """
        }
    }
    
    @Test("JSON Block Snapshot")
    func jsonBlockSnapshot() throws {
        let jsonBlock = Prism.CodeBlock.json(lineNumbers: true) {
        """
        {
            "name": "swift-html-prism",
            "version": "0.1.0",
            "languages": ["swift", "javascript", "python"]
        }
        """
        }
        
        assertInlineSnapshot(
            of: HTMLDocument { jsonBlock },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <pre class="line-numbers" ><code class="language-json">{
                "name": "swift-html-prism",
                "version": "0.1.0",
                "languages": ["swift", "javascript", "python"]
            }</code></pre>
              </body>
            </html>
            """
        }
    }
    
    @Test("Diff Block Snapshot")
    func diffBlockSnapshot() throws {
        let diffBlock = Prism.CodeBlock.diff {
        """
        - let oldValue = 42
        + let newValue = 100
          let unchanged = "same"
        """
        }
        
        assertInlineSnapshot(
            of: HTMLDocument { diffBlock },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <pre ><code class="language-diff">- let oldValue = 42
            + let newValue = 100
              let unchanged = "same"</code></pre>
              </body>
            </html>
            """
        }
    }
    
    @Test("Prism Head Minimal Snapshot")
    func prismHeadMinimalSnapshot() throws {
        let head = Prism.Head.minimal
        
        assertInlineSnapshot(
            of: HTMLDocument { head },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-numbers/prism-line-numbers.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-highlight/prism-line-highlight.min.css">
            <style>pre {
              position: relative;
              overflow-x: auto;
            }

            code[class*="language-"],
            pre[class*="language-"] {
              font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
              font-size: 14px;
              line-height: 1.5;
            }
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



            </style><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-numbers/prism-line-numbers.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-highlight/prism-line-highlight.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-javascript.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-css.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-html.min.js"></script><script>document.addEventListener("DOMContentLoaded", function () {
              if (typeof Prism !== "undefined") {
                Prism.highlightAll();  }
            });</script>
              </body>
            </html>
            """
        }
    }
    
    @Test("Prism Head Swift Configuration Snapshot")
    func prismHeadSwiftSnapshot() throws {
        let head = Prism.Head.swift
        
        assertInlineSnapshot(
            of: HTMLDocument { head },
            as: .html
        ) {
            #"""
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <style>
            .token.class-name { color: #4B21B0 }
            .token.comment { color: #707F8C }
            .token.function { color: #4B21B0 }
            .token.keyword { color: #AD3DA4 }
            .token.number { color: #D22E1B }
            .token.string { color: #D22E1B }

            </style>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-numbers/prism-line-numbers.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-highlight/prism-line-highlight.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/toolbar/prism-toolbar.min.css">
            <style>pre {
              position: relative;
              overflow-x: auto;
            }

            code[class*="language-"],
            pre[class*="language-"] {
              font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
              font-size: 14px;
              line-height: 1.5;
            }
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

            </style><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-numbers/prism-line-numbers.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-highlight/prism-line-highlight.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/copy-to-clipboard/prism-copy-to-clipboard.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/toolbar/prism-toolbar.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-swift.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-html.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-css.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-javascript.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-typescript.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-jsx.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-tsx.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-json.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-yaml.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-xml.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-csv.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-toml.min.js"></script><script>document.addEventListener("DOMContentLoaded", function () {
              if (typeof Prism !== "undefined") {
                Prism.highlightAll();    // Enhanced Swift class name detection
                if (Prism.languages.swift) {
                  Prism.languages.swift['class-name'] = [
                    /\b(_[A-Z]\w*)\b/,
                    Prism.languages.swift['class-name']
                  ];
                  
                  // Additional Swift keywords
                  Prism.languages.swift.keyword = [
                    /\b(any|macro)\b/,
                    /\b((iOS|macOS|tvOS|watchOS|visionOS)(|ApplicationExtension)|swift)\b/,
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
                }  }
            });</script>
              </body>
            </html>
            """#
        }
    }
    
    @Test("Prism Head Custom Configuration Snapshot")
    func prismHeadCustomSnapshot() throws {
        let config = Prism.Configuration(
            languages: [.swift, .javascript],
            plugins: [.lineNumbers, .copyToClipboard],
            theme: .builtin(.okaidia)
        )
        let head = Prism.Head(configuration: config)
        
        assertInlineSnapshot(
            of: HTMLDocument { head },
            as: .html
        ) {
            #"""
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-okaidia.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-numbers/prism-line-numbers.min.css">
            <style>pre {
              position: relative;
              overflow-x: auto;
            }

            code[class*="language-"],
            pre[class*="language-"] {
              font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
              font-size: 14px;
              line-height: 1.5;
            }


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

            </style><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-numbers/prism-line-numbers.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/copy-to-clipboard/prism-copy-to-clipboard.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-swift.min.js"></script><script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-javascript.min.js"></script><script>document.addEventListener("DOMContentLoaded", function () {
              if (typeof Prism !== "undefined") {
                Prism.highlightAll();    // Enhanced Swift class name detection
                if (Prism.languages.swift) {
                  Prism.languages.swift['class-name'] = [
                    /\b(_[A-Z]\w*)\b/,
                    Prism.languages.swift['class-name']
                  ];
                  
                  // Additional Swift keywords
                  Prism.languages.swift.keyword = [
                    /\b(any|macro)\b/,
                    /\b((iOS|macOS|tvOS|watchOS|visionOS)(|ApplicationExtension)|swift)\b/,
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
                }  }
            });</script>
              </body>
            </html>
            """#
        }
    }
    
    @Test("Complex CodeBlock with All Features Snapshot")
    func complexCodeBlockSnapshot() throws {
        let codeBlock = Prism.CodeBlock(
            language: .swift,
            lineNumbers: true,
            highlightLines: [1, 3, 5],
            startingLineNumber: 10,
            title: "ComplexExample.swift"
        ) {
        """
        import Foundation
        
        struct ComplexExample {
            let value: Int
            
            func compute() -> Int {
                return value * 2
            }
        }
        """
        }
        
        assertInlineSnapshot(
            of: HTMLDocument { codeBlock },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <div class="code-block-wrapper">
              <div class="code-block-title">ComplexExample.swift
              </div>
              <pre class="line-numbers" data-line="1,3,5" data-start="10"><code class="language-swift">import Foundation

            struct ComplexExample {
                let value: Int
                
                func compute() -&gt; Int {
                    return value * 2
                }
            }</code></pre>
            </div>
              </body>
            </html>
            """
        }
    }
    
    @Test("HTML CodeBlock Snapshot")
    func htmlCodeBlockSnapshot() throws {
        let htmlBlock = Prism.CodeBlock.html(
            lineNumbers: true
        ) {
        """
        <!DOCTYPE html>
        <html>
            <head>
                <title>Example</title>
            </head>
            <body>
                <h1>Hello, World!</h1>
            </body>
        </html>
        """
        }
        
        assertInlineSnapshot(
            of: HTMLDocument { htmlBlock },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <pre class="line-numbers" ><code class="language-html">&lt;!DOCTYPE html&gt;
            &lt;html&gt;
                &lt;head&gt;
                    &lt;title&gt;Example&lt;/title&gt;
                &lt;/head&gt;
                &lt;body&gt;
                    &lt;h1&gt;Hello, World!&lt;/h1&gt;
                &lt;/body&gt;
            &lt;/html&gt;</code></pre>
              </body>
            </html>
            """
        }
    }
    
    @Test("CSS CodeBlock Snapshot")
    func cssCodeBlockSnapshot() throws {
        let cssBlock = Prism.CodeBlock.css(
            lineNumbers: true
        ) {
        """
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1rem;
        }
        """
        }
        
        assertInlineSnapshot(
            of: HTMLDocument { cssBlock },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>

                </style>
              </head>
              <body>
            <pre class="line-numbers" ><code class="language-css">.container {
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 1rem;
            }</code></pre>
              </body>
            </html>
            """
        }
    }
}
