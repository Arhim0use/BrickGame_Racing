// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Race",
    products: [
        .library(
            name: "Race",
            targets: ["Race"]),
    ],
    dependencies: [
        .package(path: "../CommonBrickGame"),
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxRealm", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "Race",
            dependencies: [
                .product(name: "CommonBrickGame", package: "CommonBrickGame"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "RxRealm", package: "RxRealm"),
            ],
            path: "Sources/"
        ),
        .testTarget(
            name: "RaceTests",
            dependencies: [
                "Race",
                .product(name: "CommonBrickGame", package: "CommonBrickGame"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "RxRealm", package: "RxRealm"),
            ]
        ),
    ]
)
