import SQLite // Really: SQLite.swift
import Foundation

/// Tests running against
/// [SQLite.swift](https://github.com/stephencelis/SQLite.swift).
enum SQLiteSwiftTests {
  
  struct Order: Codable {
    let OrderID        : Int64
    let CustomerID     : String?
    let EmployeeID     : Int64?
    
    // No Date decoding here?
    let OrderDate      : String?
    let RequiredDate   : String?
    let ShippedDate    : String?
    
    let ShipVia        : Int64?
#if false // fails w/ the Codable test!
    let Freight        : String? // Decimal?
#endif
    let ShipName       : String?
    let ShipAddress    : String?
    let ShipCity       : String?
    let ShipRegion     : String?
    let ShipPostalCode : String?
    let ShipCountry    : String?
  }
  
  enum OrderTable {
    static let table          = Table("orders")
    static let OrderID        = Expression<Int64>("OrderID")
    static let CustomerID     = Expression<String?>("CustomerID")
    static let EmployeeID     = Expression<Int64?>("EmployeeID")
    
    // No Date decoding here?
    static let OrderDate      = Expression<String?>("OrderDate")
    static let RequiredDate   = Expression<String?>("RequiredDate")
    static let ShippedDate    = Expression<String?>("ShippedDate")
    
    static let ShipVia        = Expression<Int64?>("ShipVia")
    static let Freight        = Expression<String?>("Freight") // Doesn't work?
    static let ShipName       = Expression<String?>("ShipName")
    static let ShipAddress    = Expression<String?>("ShipAddress")
    static let ShipCity       = Expression<String?>("ShipCity")
    static let ShipRegion     = Expression<String?>("ShipRegion")
    static let ShipPostalCode = Expression<String?>("ShipPostalCode")
    static let ShipCountry    = Expression<String?>("ShipCountry")

    static let all : [ Expressible ] = [
      OrderID,
      CustomerID,
      EmployeeID,
      OrderDate,
      RequiredDate,
      ShippedDate,
      ShipVia,
      Freight,
      ShipName,
      ShipAddress,
      ShipCity,
      ShipRegion,
      ShipPostalCode,
      ShipCountry
    ]
  }
  
  /// This is using Codable and seems to be extremely slow w/ SQLite.swift
  /// (e.g. GRDB is massively faster).
  static let builtinModelObjectTests : [ PerfTest ] = [
    CtxPerfTest(name: "Orders.fetchAll",
                try Connection(DBPathes.northwind.path, readonly: true))
    {
      let select = OrderTable.table.select(OrderTable.all)
      
      let _ : [ Order ] // required!
            = try $0.prepare(select).map { try $0.decode() }
    }
  ]

  /// This is manually mapping the selected result, to avoid any Codable
  /// overhead.
  static let handWrittenMapping : [ PerfTest ] = [
    CtxPerfTest(name: "Orders.fetchAll",
                try Connection(DBPathes.northwind.path, readonly: true))
    {
      let select = OrderTable.table.select(OrderTable.all)
      let _ : [ Order ] = try $0.prepare(select).map { row in
        Order(
          OrderID        : row[OrderTable.OrderID],
          CustomerID     : row[OrderTable.CustomerID],
          EmployeeID     : row[OrderTable.EmployeeID],
          OrderDate      : row[OrderTable.OrderDate],
          RequiredDate   : row[OrderTable.RequiredDate],
          ShippedDate    : row[OrderTable.ShippedDate],
          ShipVia        : row[OrderTable.ShipVia],
          ShipName       : row[OrderTable.ShipName],
          ShipAddress    : row[OrderTable.ShipAddress],
          ShipCity       : row[OrderTable.ShipCity],
          ShipRegion     : row[OrderTable.ShipRegion],
          ShipPostalCode : row[OrderTable.ShipPostalCode],
          ShipCountry    : row[OrderTable.ShipCountry]
        )
      }
    }
  ]
}
