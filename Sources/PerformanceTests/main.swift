//
//  main.swift
//  PerformanceTests
//
//  Created by Helge Heß on 06.08.22.
//

import Foundation

/*
 Required Environment (needs python3):
   pushd /tmp && \
   git clone https://github.com/jpwhite3/northwind-SQLite3 && \
   cd northwind-SQLite3 && \
   make build populate && \
   popd
*/

enum DBPathes {

  
  static let northwind =
    URL(fileURLWithPath: "/tmp/northwind-SQLite3/dist/northwind.db")
  
  static let grdbPerf =
    URL(fileURLWithPath: "/tmp/GRDB.swift/Tests/Performance/GRDBProfiling/GRDBProfiling/"
    + "ProfilingDatabase.sqlite")
}


// MARK: - Setup Tests

let testMap = [
  "GRDB"               : GRDBTests.builtinModelObjectTests,
  "GRDB(manu)"         : GRDBTests.indexMappedStructureTests,
  "SQLite.swift"       : SQLiteSwiftTests.builtinModelObjectTests,
  "SQLite.swift(manu)" : SQLiteSwiftTests.handWrittenMapping,
  "Lighter"            : LighterTests.builtinModelObjectTests,
  "Enlighter SQLite"   : RawEnlighterTests.builtinModelObjectTests,
]


// MARK: - Run the Tests

do {
  PerfTest.rampupCount = 10
  PerfTest.iterations  = 500

  let startDate = Date()
  print("Start running tests:", startDate)
  
  for ( name, tests ) in testMap {
    print("  \(name):", Date())
    try tests.runAll()
  }
  
  print("Finished running tests:", Date())
}
catch {
  print("Something failed:", error)
  exit(2)
}


// MARK: - Generate output

do {
  // group by test name
  var longestTestName = 0
  var longestName     = 0
  var results = [ String : [ String : PerfTest ] ]()

  for ( name, tests ) in testMap {
    if name.count > longestName { longestName = name.count }
    for test in tests {
      if test.name.count > longestTestName { longestTestName = test.name.count }
      if results[test.name] == nil { results[test.name] = [:] }
      results[test.name]?[name] = test
    }
  }
  
  let fmt : NumberFormatter = {
    let fmt = NumberFormatter()
    fmt.maximumFractionDigits = 3
    return fmt
  }()

  let column1Padding = max(longestTestName, longestName)

  for ( test, results ) in results {
    let pTest = test.padding(toLength: column1Padding + 2, withPad: " ",
                             startingAt: 0)
    print(pTest, "setup   ", "rampup  ", "duration")
    for ( name, perf ) in results.sorted(by: { lhs, rhs in
      lhs.value.duration < rhs.value.duration
    })
    {
      let setup    = fmt.string(for: perf.setupDuration)  ?? "-"
      let rampup   = fmt.string(for: perf.rampupDuration) ?? "-"
      let duration = fmt.string(for: perf.duration)       ?? "-"
      
      print(" ",
        name    .padding(toLength: column1Padding, withPad: " ", startingAt: 0),
        setup   .padding(toLength: 8, withPad: " ", startingAt: 0),
        rampup  .padding(toLength: 8, withPad: " ", startingAt: 0),
        duration.padding(toLength: 8, withPad: " ", startingAt: 0)
      )
    }
  }
}
