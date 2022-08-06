//
//  RawEnlighterTests.swift
//  PerformanceTests
//
//  Created by Helge Heß on 06.08.22.
//

import Foundation
import SQLite3

enum RawEnlighterTests {

  static private func open() -> OpaquePointer! {
    var db : OpaquePointer?
    let rc = sqlite3_open_v2(DBPathes.northwind.path, &db,
                             SQLITE_OPEN_READONLY, nil)
    assert(rc == SQLITE_OK && db != nil)
    return db
  }

  static let builtinModelObjectTests : [ PerfTest ] = [
    CtxPerfTest(name: "Orders.fetchAll", open()) {
      _ = NorthwindLighter.Order.fetch(from: $0)
    }
  ]
}
