// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension String {
    static let htmlPrism: Self = "HTMLPrism"
}

extension Target.Dependency {
    static var htmlPrism: Self { .target(name: .htmlPrism) }
}

extension Target.Dependency {
    static var html: Self { .product(name: "HTML", package: "swift-html") }
    static var htmlTheme: Self { .product(name: "HTMLTheme", package: "swift-html") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var pointFreeHtmlTestSupport: Self { .product(name: "PointFreeHTMLTestSupport", package: "pointfree-html") }
}

let package = Package(
    name: "swift-html-prism",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .macCatalyst(.v17)
    ],
    products: [
        .library(name: .htmlPrism, targets: [.htmlPrism])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-html", branch: "main"),
        .package(url: "https://github.com/coenttb/pointfree-html", from: "2.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2")
    ],
    targets: [
        .target(
            name: .htmlPrism,
            dependencies: [
                .html,
                .htmlTheme,
                .dependencies
            ]
        ),
        .testTarget(
            name: .htmlPrism.tests,
            dependencies: [
                .htmlPrism,
                .pointFreeHtmlTestSupport
            ]
        )
    ]
)

extension String {
    var tests: Self { "\(self) Tests" }
}
