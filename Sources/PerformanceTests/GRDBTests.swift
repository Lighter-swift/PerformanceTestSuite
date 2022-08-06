import GRDB
import Foundation

enum GRDBTests {
  
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
}
