// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cliBrickGame",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "BrickGame",
            targets: ["cliBrickGame"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/dduan/Termbox", from: "1.0.1"),
        .package(path: "../../brick_game/Race/")
    ],
    targets: [
        .executableTarget(
            name: "cliBrickGame",
            dependencies: [
                .product(name: "Race", package: "Race"),
                "Termbox"
            ],
            path: "Sources"
        ),
    ]
)
