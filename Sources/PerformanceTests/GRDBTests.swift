import GRDB
import Foundation

enum GRDBTests {
  
  /// Lotsa code, but fast path from GRDB:
  /// - https://github.com/groue/GRDB.swift
  struct FixedOrders: Codable, FetchableRecord, TableRecord {

    static let databaseTableName = "Orders"
    
    var OrderID        : Int64
    var CustomerID     : String?
    var EmployeeID     : Int64?
    
    // No Date decoding here?
    var OrderDate      : String? // 2019-02-10 04:59:33
    var RequiredDate   : String?
    var ShippedDate    : String?
    
    var ShipVia        : Int64?
    
    var Freight        : Decimal?
    
    var ShipName       : String?
    var ShipAddress    : String?
    var ShipCity       : String?
    var ShipRegion     : String?
    var ShipPostalCode : String?
    var ShipCountry    : String?
    
    /// The table columns
    enum Columns {
      static let OrderID        = Column(CodingKeys.OrderID)
      static let CustomerID     = Column(CodingKeys.CustomerID)
      static let EmployeeID     = Column(CodingKeys.EmployeeID)
      static let OrderDate      = Column(CodingKeys.OrderDate)
      static let RequiredDate   = Column(CodingKeys.RequiredDate)
      static let ShippedDate    = Column(CodingKeys.ShippedDate)
      static let ShipVia        = Column(CodingKeys.ShipVia)
      static let Freight        = Column(CodingKeys.Freight)
      static let ShipName       = Column(CodingKeys.ShipName)
      static let ShipAddress    = Column(CodingKeys.ShipAddress)
      static let ShipCity       = Column(CodingKeys.ShipCity)
      static let ShipRegion     = Column(CodingKeys.ShipRegion)
      static let ShipPostalCode = Column(CodingKeys.ShipPostalCode)
      static let ShipCountry    = Column(CodingKeys.ShipCountry)
    }
    
    /// Arrange the selected columns and lock their order
    static let databaseSelection: [SQLSelectable] = [
      Columns.OrderID,
      Columns.CustomerID,
      Columns.EmployeeID,
      Columns.OrderDate,
      Columns.RequiredDate,
      Columns.ShippedDate,
      Columns.ShipVia,
      Columns.Freight,
      Columns.ShipName,
      Columns.ShipAddress,
      Columns.ShipCity,
      Columns.ShipRegion,
      Columns.ShipPostalCode,
      Columns.ShipCountry
    ]
    /// Creates a record from a database row
    init(row: Row) {
      // For high performance, use numeric indexes that match the
      // order of Place.databaseSelection
      OrderID        = row[0]
      CustomerID     = row[1]
      EmployeeID     = row[2]
      OrderDate      = row[3]
      RequiredDate   = row[4]
      ShippedDate    = row[5]
      ShipVia        = row[6]
      Freight        = row[7]
      ShipName       = row[8]
      ShipAddress    = row[9]
      ShipCity       = row[10]
      ShipRegion     = row[11]
      ShipPostalCode = row[12]
      ShipCountry    = row[13]
    }
  }
  
  struct Orders: Codable, FetchableRecord, PersistableRecord {
    var OrderID        : Int64
    var CustomerID     : String?
    var EmployeeID     : Int64?
    
    // No Date decoding here?
    var OrderDate      : String? // 2019-02-10 04:59:33
    var RequiredDate   : String?
    var ShippedDate    : String?
    
    var ShipVia        : Int64?
    
    var Freight        : Decimal?
    
    var ShipName       : String?
    var ShipAddress    : String?
    var ShipCity       : String?
    var ShipRegion     : String?
    var ShipPostalCode : String?
    var ShipCountry    : String?
  }
  
  static let config : Configuration = {
    var defaultConfig = Configuration()
    defaultConfig.readonly = true
    return defaultConfig
  }()
  
  static let builtinModelObjectTests : [ PerfTest ] = [
    CtxPerfTest(name: "Orders.fetchAll",
                try DatabaseQueue(path: DBPathes.northwind.path,
                                  configuration: config))
    {
      let _ : [ Orders ] = try $0.read { db in
        try Orders.fetchAll(db)
      }
    }
  ]
  
  
  static let indexMappedStructureTests : [ PerfTest ] = [
    CtxPerfTest(name: "Orders.fetchAll",
                try DatabaseQueue(path: DBPathes.northwind.path,
                                  configuration: config))
    {
      let _ : [ FixedOrders ] = try $0.read { db in
        try FixedOrders.fetchAll(db)
      }
    }
  ]
}
