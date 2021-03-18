//
//  Package.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/3/18.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HLYNetworking",
    platforms: [
        .iOS(.v12), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "HLYNetworking",
            targets: ["HLYNetworking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.1"),
    ],
    targets: [
        .target(
            name: "HLYNetworking",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "HLYNetworkingTests",
            dependencies: ["HLYNetworking"]),
    ],
    swiftLanguageVersions: [.v5]
)
