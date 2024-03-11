// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ZeroAuth",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "ZeroAuthCore",
            targets: ["ZeroAuthCore"]),
        .library(
            name: "ZeroAuth",
            targets: ["ZeroAuth"]),
    ],
    dependencies: [
        .package(url: "https://github.com/openid/AppAuth-iOS.git", .upToNextMajor(from: "1.6.2")),
        .package(url: "https://github.com/mcxross/swift-suiness.git", .upToNextMajor(from: "0.1.2-beta")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.1")),
        .package(url: "https://github.com/Kitura/Swift-JWT.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "ZeroAuthCore",
            dependencies: [
                .product(name: "AppAuth", package: "AppAuth-iOS"),
                .product(name: "Suiness", package: "swift-suiness"),
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "Sources/ZeroAuthCore"),
        .target(
            name: "ZeroAuth",
            dependencies: ["ZeroAuthCore"],
            path: "Sources/ZeroAuth",
            sources: ["iOS", "macOS"]),
        .testTarget(
            name: "ZeroAuthTests",
            dependencies: ["ZeroAuth"]),
    ]
)
