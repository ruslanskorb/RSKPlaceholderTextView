// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "RSKPlaceholderTextView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "RSKPlaceholderTextView", targets: ["RSKPlaceholderTextView"])
    ],
    targets: [
        .target(name: "RSKPlaceholderTextView", path: "RSKPlaceholderTextView")
    ],
    swiftLanguageVersions: [.v5]
)
