// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnleashClient",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UnleashClient",
            targets: ["UnleashClient"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/mxcl/PromiseKit", from: "7.0.0-rc1"),
        .package(url: "https://github.com/Quick/Quick", from: "5.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "10.0.0"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .upToNextMajor(from: "9.0.0")),
        .package(url: "https://github.com/daisuke-t-jp/MurmurHash-Swift", from: "1.1.1"),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UnleashClient",
            dependencies: [
                .product(name: "PMKFoundation", package: "PromiseKit"),
                .product(name: "MurmurHash-Swift", package: "MurmurHash-Swift"),
            ], path: "./Source/UnleashClientPackage"
        ),
        .testTarget(
            name: "unleash-client-swiftTests",
            dependencies: ["UnleashClient",
                           "Quick",
                           .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
                           "Nimble"],
            path: "./Tests/UnleashClientTests"
        ),
    ]
)
