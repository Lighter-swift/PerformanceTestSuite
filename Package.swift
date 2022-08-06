// swift-tools-version:5.7

import PackageDescription

var package = Package(
  name: "PerformanceTests",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [
    .executable(name: "PerformanceTests", targets: [ "PerformanceTests" ])
  ],
  
  dependencies: [
    .package(url: "git@github.com:55DB091A-8471-447B-8F50-5DFF4C1B14AC/Lighter.git",
             branch: "develop"),
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
