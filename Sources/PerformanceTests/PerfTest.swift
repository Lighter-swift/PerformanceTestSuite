//
//  PerfTest.swift
//  PerformanceTests
//
//  Created by Helge Heß on 06.08.22.
//

import Foundation

extension Array where Element == PerfTest {
  
  func runAll() throws {
    try forEach { try $0.run() }
  }
}

class PerfTest {
  
  let name             : String
  
  static var rampupCount      = 3
  static var iterations       = 10
  
  var setupDuration    : TimeInterval = 1_000_000
  var rampupDuration   : TimeInterval = 1_000_000
  var duration         : TimeInterval = 1_000_000
  var total            : TimeInterval = 1_000_000
  
  init(name: String) {
    self.name = name
  }
  
  func run() throws {
    fatalError("Subclass responsibility")
  }
}

final class CtxPerfTest<Context>: PerfTest {

  let setup : () throws -> Context
  let test  : ( Context ) throws -> Void
  
  init(name: String,
       _ setup: @autoclosure @escaping () throws -> Context,
       test: @escaping ( Context ) throws -> Void)
  {
    self.setup = setup
    self.test  = test
    super.init(name: name)
  }
  
  override func run() throws {
    let start = Date()
    defer { total = -start.timeIntervalSinceNow }
    
    let ctx = try setup()
    setupDuration = -start.timeIntervalSinceNow
    
    // ramp up
    do {
      let rampUpstart = Date()
      for _ in 1...Self.rampupCount {
        try test(ctx)
      }
      rampupDuration = -rampUpstart.timeIntervalSinceNow
    }
    
    // tests
    do {
      let rampUpstart = Date()
      for _ in 1...Self.iterations {
        try test(ctx)
      }
      duration = -rampUpstart.timeIntervalSinceNow
    }
  }
}
