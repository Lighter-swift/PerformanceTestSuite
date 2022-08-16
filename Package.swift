// swift-tools-version:5.7

import PackageDescription

var package = Package(
  name: "PerformanceTests",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [
    .executable(name: "PerformanceTests", targets: [ "PerformanceTests" ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Lighter-swift/Lighter.git",
             from: "1.0.2"),
    .package(url: "https://github.com/stephencelis/SQLite.swift", 
             from: "0.9.2"),
    .package(url: "https://github.com/groue/GRDB.swift", from: "5.26.0")
  ],
  
  targets: [
    .executableTarget(
      name         : "PerformanceTests",
      dependencies : [ 
        "Lighter", 
        .product(name: "GRDB", package: "GRDB.swift"), 
        .product(name: "SQLite", package: "SQLite.swift")
      ]
    )
  ]
)
