//
//  LighterTests.swift
//  PerformanceTests
//
//  Created by Helge Heß on 06.08.22.
//

import Foundation
import Lighter
import SQLite3

enum LighterTests {
  
  private static func setupNonPooledConnection() -> NorthwindLighter {
    // vs: NorthwindLighter(url: DBPathes.northwind))
    // This replicates what the others do and avoids the pool overhead
    // (and potential open calls which we don't want to measure, we want to
    //  measure the mapping performance).
    var db : OpaquePointer?
    let rc = sqlite3_open_v2(DBPathes.northwind.path, &db,
                             SQLITE_OPEN_READONLY, nil)
    assert(rc == SQLITE_OK && db != nil)
    
    // This is unsafe in the way that the same database struct is going to
    // reuse the same handle, e.g. during concurrent thread fetches against
    // the same DB. We don't have this in our perf test.
    return NorthwindLighter(connectionHandler:
        .unsafeReuse(db, url: DBPathes.northwind))
  }

  static let builtinModelObjectTests : [ PerfTest ] = [
    CtxPerfTest(name: "Orders.fetchAll", setupNonPooledConnection()) {
      _ = try $0.orders.fetch()
    }
  ]
}
