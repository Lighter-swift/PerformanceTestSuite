import SQLite3
import Foundation
import Lighter

/**
 * A structure representing a SQLite database.
 *
 * ### Database Schema
 *
 * The schema captures the SQLite table/view catalog as safe Swift types.
 *
 * #### Tables
 *
 * - ``Category``                   (SQL: `Categories`)
 * - ``CustomerCustomerDemo``       (SQL: `CustomerCustomerDemo`)
 * - ``CustomerDemographic``        (SQL: `CustomerDemographics`)
 * - ``Customer``                   (SQL: `Customers`)
 * - ``Employee``                   (SQL: `Employees`)
 * - ``EmployeeTerritory``          (SQL: `EmployeeTerritories`)
 * - ``OrderDetail``                (SQL: `Order Details`)
 * - ``Order``                      (SQL: `Orders`)
 * - ``Product``                    (SQL: `Products`)
 * - ``Region``                     (SQL: `Regions`)
 * - ``Shipper``                    (SQL: `Shippers`)
 * - ``Supplier``                   (SQL: `Suppliers`)
 * - ``Territory``                  (SQL: `Territories`)
 *
 * #### Views
 *
 * - ``AlphabeticalListOfProduct``  (SQL: `Alphabetical list of products`)
 * - ``CurrentProductList``         (SQL: `Current Product List`)
 * - ``CustomerAndSuppliersByCity`` (SQL: `Customer and Suppliers by City`)
 * - ``Invoice``                    (SQL: `Invoices`)
 * - ``OrdersQry``                  (SQL: `Orders Qry`)
 * - ``OrderSubtotal``              (SQL: `Order Subtotals`)
 * - ``ProductSalesFor1997``        (SQL: `Product Sales for 1997`)
 * - ``ProductsAboveAveragePrice``  (SQL: `Products Above Average Price`)
 * - ``ProductsByCategory``         (SQL: `Products by Category`)
 * - ``QuarterlyOrder``             (SQL: `Quarterly Orders`)
 * - ``SalesTotalsByAmount``        (SQL: `Sales Totals by Amount`)
 * - ``SummaryOfSalesByQuarter``    (SQL: `Summary of Sales by Quarter`)
 * - ``SummaryOfSalesByYear``       (SQL: `Summary of Sales by Year`)
 * - ``CategorySalesFor1997``       (SQL: `Category Sales for 1997`)
 * - ``OrderDetailsExtended``       (SQL: `Order Details Extended`)
 * - ``SalesByCategory``            (SQL: `Sales by Category`)
 *
 *
 * ### Examples
 *
 * Perform record operations on ``Category`` records:
 * ```swift
 * let records = try await db.categories.filter(orderBy: \.categoryName) {
 *   $0.categoryName != nil
 * }
 * ```
 *
 * Perform column selects on the `Categories` table:
 * ```swift
 * let values = try await db.select(from: \.categories, \.categoryName) {
 *   $0.in([ 2, 3 ])
 * }
 * ```
 *
 * Perform low level operations on ``Category`` records:
 * ```swift
 * var db : OpaquePointer?
 * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
 *
 * let records = Category.fetch(in: db, orderBy: "categoryName", limit: 5) {
 *   $0.categoryName != nil
 * }
 * ```
 */
@dynamicMemberLookup
public struct NorthwindLighter : SQLDatabase, SQLDatabaseFetchOperations {
  
  /**
   * Mappings of table/view Swift types to their "reference name".
   *
   * The `RecordTypes` structure contains a variable for the Swift type
   * associated each table/view of the database. It maps the tables
   * "reference names" (e.g. ``categories``) to the
   * "record type" of the table (e.g. ``Category``.self).
   */
  public struct RecordTypes {
    
    /// Returns the Category type information (SQL: `Categories`).
    public let categories = Category.self
    
    /// Returns the CustomerCustomerDemo type information (SQL: `CustomerCustomerDemo`).
    public let customerCustomerDemos = CustomerCustomerDemo.self
    
    /// Returns the CustomerDemographic type information (SQL: `CustomerDemographics`).
    public let customerDemographics = CustomerDemographic.self
    
    /// Returns the Customer type information (SQL: `Customers`).
    public let customers = Customer.self
    
    /// Returns the Employee type information (SQL: `Employees`).
    public let employees = Employee.self
    
    /// Returns the EmployeeTerritory type information (SQL: `EmployeeTerritories`).
    public let employeeTerritories = EmployeeTerritory.self
    
    /// Returns the OrderDetail type information (SQL: `Order Details`).
    public let orderDetails = OrderDetail.self
    
    /// Returns the Order type information (SQL: `Orders`).
    public let orders = Order.self
    
    /// Returns the Product type information (SQL: `Products`).
    public let products = Product.self
    
    /// Returns the Region type information (SQL: `Regions`).
    public let regions = Region.self
    
    /// Returns the Shipper type information (SQL: `Shippers`).
    public let shippers = Shipper.self
    
    /// Returns the Supplier type information (SQL: `Suppliers`).
    public let suppliers = Supplier.self
    
    /// Returns the Territory type information (SQL: `Territories`).
    public let territories = Territory.self
    
    /// Returns the AlphabeticalListOfProduct type information (SQL: `Alphabetical list of products`).
    public let alphabeticalListOfProducts = AlphabeticalListOfProduct.self
    
    /// Returns the CurrentProductList type information (SQL: `Current Product List`).
    public let currentProductLists = CurrentProductList.self
    
    /// Returns the CustomerAndSuppliersByCity type information (SQL: `Customer and Suppliers by City`).
    public let customerAndSuppliersByCities = CustomerAndSuppliersByCity.self
    
    /// Returns the Invoice type information (SQL: `Invoices`).
    public let invoices = Invoice.self
    
    /// Returns the OrdersQry type information (SQL: `Orders Qry`).
    public let ordersQries = OrdersQry.self
    
    /// Returns the OrderSubtotal type information (SQL: `Order Subtotals`).
    public let orderSubtotals = OrderSubtotal.self
    
    /// Returns the ProductSalesFor1997 type information (SQL: `Product Sales for 1997`).
    public let productSalesFor1997s = ProductSalesFor1997.self
    
    /// Returns the ProductsAboveAveragePrice type information (SQL: `Products Above Average Price`).
    public let productsAboveAveragePrices = ProductsAboveAveragePrice.self
    
    /// Returns the ProductsByCategory type information (SQL: `Products by Category`).
    public let productsByCategories = ProductsByCategory.self
    
    /// Returns the QuarterlyOrder type information (SQL: `Quarterly Orders`).
    public let quarterlyOrders = QuarterlyOrder.self
    
    /// Returns the SalesTotalsByAmount type information (SQL: `Sales Totals by Amount`).
    public let salesTotalsByAmounts = SalesTotalsByAmount.self
    
    /// Returns the SummaryOfSalesByQuarter type information (SQL: `Summary of Sales by Quarter`).
    public let summaryOfSalesByQuarters = SummaryOfSalesByQuarter.self
    
    /// Returns the SummaryOfSalesByYear type information (SQL: `Summary of Sales by Year`).
    public let summaryOfSalesByYears = SummaryOfSalesByYear.self
    
    /// Returns the CategorySalesFor1997 type information (SQL: `Category Sales for 1997`).
    public let categorySalesFor1997s = CategorySalesFor1997.self
    
    /// Returns the OrderDetailsExtended type information (SQL: `Order Details Extended`).
    public let orderDetailsExtendeds = OrderDetailsExtended.self
    
    /// Returns the SalesByCategory type information (SQL: `Sales by Category`).
    public let salesByCategories = SalesByCategory.self
  }
  
  /**
   * Record representing the `Categories` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Category`` records:
   * ```swift
   * let records = try await db.categories.filter(orderBy: \.categoryName) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * Perform column selects on the `Categories` table:
   * ```swift
   * let values = try await db.select(from: \.categories, \.categoryName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Category`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Category.fetch(in: db, orderBy: "categoryName", limit: 5) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Categories]
   * (      [CategoryID] INTEGER PRIMARY KEY AUTOINCREMENT,
   *        [CategoryName] TEXT,
   *        [Description] TEXT,
   *        [Picture] BLOB
   * )
   * ```
   */
  public struct Category : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Category`` record.
    public static let schema = Schema()
    
    /// Primary key `CategoryID` (`INTEGER`), optional (default: `nil`).
    public var id : Int?
    
    /// Column `CategoryName` (`TEXT`), optional (default: `nil`).
    public var categoryName : String?
    
    /// Column `Description` (`TEXT`), optional (default: `nil`).
    public var description : String?
    
    /// Column `Picture` (`BLOB`), optional (default: `nil`).
    public var picture : [ UInt8 ]?
    
    /**
     * Initialize a new ``Category`` record.
     *
     * - Parameters:
     *   - id: Primary key `CategoryID` (`INTEGER`), optional (default: `nil`).
     *   - categoryName: Column `CategoryName` (`TEXT`), optional (default: `nil`).
     *   - description: Column `Description` (`TEXT`), optional (default: `nil`).
     *   - picture: Column `Picture` (`BLOB`), optional (default: `nil`).
     */
    @inlinable
    public init(
      id: Int? = nil,
      categoryName: String? = nil,
      description: String? = nil,
      picture: [ UInt8 ]? = nil
    )
    {
      self.id = id
      self.categoryName = categoryName
      self.description = description
      self.picture = picture
    }
  }
  
  /**
   * Record representing the `CustomerCustomerDemo` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``CustomerCustomerDemo`` records:
   * ```swift
   * let records = try await db.customerCustomerDemos.filter(orderBy: \.customerID) {
   *   $0.customerID != nil
   * }
   * ```
   *
   * Perform column selects on the `CustomerCustomerDemo` table:
   * ```swift
   * let values = try await db.select(from: \.customerCustomerDemos, \.customerID) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``CustomerCustomerDemo`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = CustomerCustomerDemo.fetch(in: db, orderBy: "customerID", limit: 5) {
   *   $0.customerID != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [CustomerCustomerDemo](
   *    [CustomerID]TEXT NOT NULL,
   *    [CustomerTypeID]TEXT NOT NULL,
   *    PRIMARY KEY ("CustomerID","CustomerTypeID"),
   *    FOREIGN KEY ([CustomerID]) REFERENCES [Customers] ([CustomerID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION,
   *   FOREIGN KEY ([CustomerTypeID]) REFERENCES [CustomerDemographics] ([CustomerTypeID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION
   * )
   * ```
   */
  public struct CustomerCustomerDemo : Identifiable, SQLTableRecord, Codable {
    
    /**
     * ID structure representing the compound key of ``CustomerCustomerDemo``.
     */
    public struct ID : Hashable {
      
      public let customerID : String
      public let customerTypeID : String
      
      /**
       * Initialize a compound ``CustomerCustomerDemo`` ``ID``
       *
       * - Parameters:
       *   - customerID: Value of ``CustomerCustomerDemo/customerID``.
       *   - customerTypeID: Value of ``CustomerCustomerDemo/customerTypeID``.
       */
      @inlinable
      public init(_ customerID: String, _ customerTypeID: String)
      {
        self.customerID = customerID
        self.customerTypeID = customerTypeID
      }
    }
    
    /// Static SQL type information for the ``CustomerCustomerDemo`` record.
    public static let schema = Schema()
    
    /// Primary key `CustomerID` (`TEXT`), required (has default).
    public var customerID : String
    
    /// Primary key `CustomerTypeID` (`TEXT`), required (has default).
    public var customerTypeID : String
    
    /// Returns the compound primary key of ``CustomerCustomerDemo`` (customerID, customerTypeID).
    @inlinable
    public var id : ID { ID(customerID, customerTypeID) }
    
    /**
     * Initialize a new ``CustomerCustomerDemo`` record.
     *
     * - Parameters:
     *   - customerID: Primary key `CustomerID` (`TEXT`), required (has default).
     *   - customerTypeID: Primary key `CustomerTypeID` (`TEXT`), required (has default).
     */
    @inlinable
    public init(customerID: String, customerTypeID: String)
    {
      self.customerID = customerID
      self.customerTypeID = customerTypeID
    }
  }
  
  /**
   * Record representing the `CustomerDemographics` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``CustomerDemographic`` records:
   * ```swift
   * let records = try await db.customerDemographics.filter(orderBy: \.id) {
   *   $0.id != nil
   * }
   * ```
   *
   * Perform column selects on the `CustomerDemographics` table:
   * ```swift
   * let values = try await db.select(from: \.customerDemographics, \.id) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``CustomerDemographic`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = CustomerDemographic.fetch(in: db, orderBy: "id", limit: 5) {
   *   $0.id != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [CustomerDemographics](
   *    [CustomerTypeID]TEXT NOT NULL,
   *    [CustomerDesc]TEXT,
   *     PRIMARY KEY ("CustomerTypeID")
   * )
   * ```
   */
  public struct CustomerDemographic : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``CustomerDemographic`` record.
    public static let schema = Schema()
    
    /// Primary key `CustomerTypeID` (`TEXT`), required (has default).
    public var id : String
    
    /// Column `CustomerDesc` (`TEXT`), optional (default: `nil`).
    public var customerDesc : String?
    
    /**
     * Initialize a new ``CustomerDemographic`` record.
     *
     * - Parameters:
     *   - id: Primary key `CustomerTypeID` (`TEXT`), required (has default).
     *   - customerDesc: Column `CustomerDesc` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(id: String, customerDesc: String? = nil)
    {
      self.id = id
      self.customerDesc = customerDesc
    }
  }
  
  /**
   * Record representing the `Customers` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Customer`` records:
   * ```swift
   * let records = try await db.customers.filter(orderBy: \.id) {
   *   $0.id != nil
   * }
   * ```
   *
   * Perform column selects on the `Customers` table:
   * ```swift
   * let values = try await db.select(from: \.customers, \.id) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Customer`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Customer.fetch(in: db, orderBy: "id", limit: 5) {
   *   $0.id != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Customers]
   * (      [CustomerID] TEXT,
   *        [CompanyName] TEXT,
   *        [ContactName] TEXT,
   *        [ContactTitle] TEXT,
   *        [Address] TEXT,
   *        [City] TEXT,
   *        [Region] TEXT,
   *        [PostalCode] TEXT,
   *        [Country] TEXT,
   *        [Phone] TEXT,
   *        [Fax] TEXT,
   *        PRIMARY KEY (`CustomerID`)
   * )
   * ```
   */
  public struct Customer : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Customer`` record.
    public static let schema = Schema()
    
    /// Primary key `CustomerID` (`TEXT`), optional (default: `nil`).
    public var id : String?
    
    /// Column `CompanyName` (`TEXT`), optional (default: `nil`).
    public var companyName : String?
    
    /// Column `ContactName` (`TEXT`), optional (default: `nil`).
    public var contactName : String?
    
    /// Column `ContactTitle` (`TEXT`), optional (default: `nil`).
    public var contactTitle : String?
    
    /// Column `Address` (`TEXT`), optional (default: `nil`).
    public var address : String?
    
    /// Column `City` (`TEXT`), optional (default: `nil`).
    public var city : String?
    
    /// Column `Region` (`TEXT`), optional (default: `nil`).
    public var region : String?
    
    /// Column `PostalCode` (`TEXT`), optional (default: `nil`).
    public var postalCode : String?
    
    /// Column `Country` (`TEXT`), optional (default: `nil`).
    public var country : String?
    
    /// Column `Phone` (`TEXT`), optional (default: `nil`).
    public var phone : String?
    
    /// Column `Fax` (`TEXT`), optional (default: `nil`).
    public var fax : String?
    
    /**
     * Initialize a new ``Customer`` record.
     *
     * - Parameters:
     *   - id: Primary key `CustomerID` (`TEXT`), optional (default: `nil`).
     *   - companyName: Column `CompanyName` (`TEXT`), optional (default: `nil`).
     *   - contactName: Column `ContactName` (`TEXT`), optional (default: `nil`).
     *   - contactTitle: Column `ContactTitle` (`TEXT`), optional (default: `nil`).
     *   - address: Column `Address` (`TEXT`), optional (default: `nil`).
     *   - city: Column `City` (`TEXT`), optional (default: `nil`).
     *   - region: Column `Region` (`TEXT`), optional (default: `nil`).
     *   - postalCode: Column `PostalCode` (`TEXT`), optional (default: `nil`).
     *   - country: Column `Country` (`TEXT`), optional (default: `nil`).
     *   - phone: Column `Phone` (`TEXT`), optional (default: `nil`).
     *   - fax: Column `Fax` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(
      id: String? = nil,
      companyName: String? = nil,
      contactName: String? = nil,
      contactTitle: String? = nil,
      address: String? = nil,
      city: String? = nil,
      region: String? = nil,
      postalCode: String? = nil,
      country: String? = nil,
      phone: String? = nil,
      fax: String? = nil
    )
    {
      self.id = id
      self.companyName = companyName
      self.contactName = contactName
      self.contactTitle = contactTitle
      self.address = address
      self.city = city
      self.region = region
      self.postalCode = postalCode
      self.country = country
      self.phone = phone
      self.fax = fax
    }
  }
  
  /**
   * Record representing the `Employees` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Employee`` records:
   * ```swift
   * let records = try await db.employees.filter(orderBy: \.lastName) {
   *   $0.lastName != nil
   * }
   * ```
   *
   * Perform column selects on the `Employees` table:
   * ```swift
   * let values = try await db.select(from: \.employees, \.lastName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Employee`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Employee.fetch(in: db, orderBy: "lastName", limit: 5) {
   *   $0.lastName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Employees]
   * (      [EmployeeID] INTEGER PRIMARY KEY AUTOINCREMENT,
   *        [LastName] TEXT,
   *        [FirstName] TEXT,
   *        [Title] TEXT,
   *        [TitleOfCourtesy] TEXT,
   *        [BirthDate] DATE,
   *        [HireDate] DATE,
   *        [Address] TEXT,
   *        [City] TEXT,
   *        [Region] TEXT,
   *        [PostalCode] TEXT,
   *        [Country] TEXT,
   *        [HomePhone] TEXT,
   *        [Extension] TEXT,
   *        [Photo] BLOB,
   *        [Notes] TEXT,
   *        [ReportsTo] INTEGER,
   *        [PhotoPath] TEXT,
   *      FOREIGN KEY ([ReportsTo]) REFERENCES [Employees] ([EmployeeID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION
   * )
   * ```
   */
  public struct Employee : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Employee`` record.
    public static let schema = Schema()
    
    /// Primary key `EmployeeID` (`INTEGER`), optional (default: `nil`).
    public var id : Int?
    
    /// Column `LastName` (`TEXT`), optional (default: `nil`).
    public var lastName : String?
    
    /// Column `FirstName` (`TEXT`), optional (default: `nil`).
    public var firstName : String?
    
    /// Column `Title` (`TEXT`), optional (default: `nil`).
    public var title : String?
    
    /// Column `TitleOfCourtesy` (`TEXT`), optional (default: `nil`).
    public var titleOfCourtesy : String?
    
    /// Column `BirthDate` (`DATE`), optional (default: `nil`).
    public var birthDate : String?
    
    /// Column `HireDate` (`DATE`), optional (default: `nil`).
    public var hireDate : String?
    
    /// Column `Address` (`TEXT`), optional (default: `nil`).
    public var address : String?
    
    /// Column `City` (`TEXT`), optional (default: `nil`).
    public var city : String?
    
    /// Column `Region` (`TEXT`), optional (default: `nil`).
    public var region : String?
    
    /// Column `PostalCode` (`TEXT`), optional (default: `nil`).
    public var postalCode : String?
    
    /// Column `Country` (`TEXT`), optional (default: `nil`).
    public var country : String?
    
    /// Column `HomePhone` (`TEXT`), optional (default: `nil`).
    public var homePhone : String?
    
    /// Column `Extension` (`TEXT`), optional (default: `nil`).
    public var `extension` : String?
    
    /// Column `Photo` (`BLOB`), optional (default: `nil`).
    public var photo : [ UInt8 ]?
    
    /// Column `Notes` (`TEXT`), optional (default: `nil`).
    public var notes : String?
    
    /// Column `ReportsTo` (`INTEGER`), optional (default: `nil`).
    public var reportsTo : Int?
    
    /// Column `PhotoPath` (`TEXT`), optional (default: `nil`).
    public var photoPath : String?
    
    /**
     * Initialize a new ``Employee`` record.
     *
     * - Parameters:
     *   - id: Primary key `EmployeeID` (`INTEGER`), optional (default: `nil`).
     *   - lastName: Column `LastName` (`TEXT`), optional (default: `nil`).
     *   - firstName: Column `FirstName` (`TEXT`), optional (default: `nil`).
     *   - title: Column `Title` (`TEXT`), optional (default: `nil`).
     *   - titleOfCourtesy: Column `TitleOfCourtesy` (`TEXT`), optional (default: `nil`).
     *   - birthDate: Column `BirthDate` (`DATE`), optional (default: `nil`).
     *   - hireDate: Column `HireDate` (`DATE`), optional (default: `nil`).
     *   - address: Column `Address` (`TEXT`), optional (default: `nil`).
     *   - city: Column `City` (`TEXT`), optional (default: `nil`).
     *   - region: Column `Region` (`TEXT`), optional (default: `nil`).
     *   - postalCode: Column `PostalCode` (`TEXT`), optional (default: `nil`).
     *   - country: Column `Country` (`TEXT`), optional (default: `nil`).
     *   - homePhone: Column `HomePhone` (`TEXT`), optional (default: `nil`).
     *   - extension: Column `Extension` (`TEXT`), optional (default: `nil`).
     *   - photo: Column `Photo` (`BLOB`), optional (default: `nil`).
     *   - notes: Column `Notes` (`TEXT`), optional (default: `nil`).
     *   - reportsTo: Column `ReportsTo` (`INTEGER`), optional (default: `nil`).
     *   - photoPath: Column `PhotoPath` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(
      id: Int? = nil,
      lastName: String? = nil,
      firstName: String? = nil,
      title: String? = nil,
      titleOfCourtesy: String? = nil,
      birthDate: String? = nil,
      hireDate: String? = nil,
      address: String? = nil,
      city: String? = nil,
      region: String? = nil,
      postalCode: String? = nil,
      country: String? = nil,
      homePhone: String? = nil,
      `extension`: String? = nil,
      photo: [ UInt8 ]? = nil,
      notes: String? = nil,
      reportsTo: Int? = nil,
      photoPath: String? = nil
    )
    {
      self.id = id
      self.lastName = lastName
      self.firstName = firstName
      self.title = title
      self.titleOfCourtesy = titleOfCourtesy
      self.birthDate = birthDate
      self.hireDate = hireDate
      self.address = address
      self.city = city
      self.region = region
      self.postalCode = postalCode
      self.country = country
      self.homePhone = homePhone
      self.`extension` = `extension`
      self.photo = photo
      self.notes = notes
      self.reportsTo = reportsTo
      self.photoPath = photoPath
    }
  }
  
  /**
   * Record representing the `EmployeeTerritories` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``EmployeeTerritory`` records:
   * ```swift
   * let records = try await db.employeeTerritories.filter(orderBy: \.territoryID) {
   *   $0.territoryID != nil
   * }
   * ```
   *
   * Perform column selects on the `EmployeeTerritories` table:
   * ```swift
   * let values = try await db.select(from: \.employeeTerritories, \.territoryID) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``EmployeeTerritory`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = EmployeeTerritory.fetch(in: db, orderBy: "territoryID", limit: 5) {
   *   $0.territoryID != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [EmployeeTerritories](
   *    [EmployeeID]INTEGER NOT NULL,
   *    [TerritoryID]TEXT NOT NULL,
   *     PRIMARY KEY ("EmployeeID","TerritoryID"),
   *   FOREIGN KEY ([EmployeeID]) REFERENCES [Employees] ([EmployeeID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION,
   *   FOREIGN KEY ([TerritoryID]) REFERENCES [Territories] ([TerritoryID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION
   * )
   * ```
   */
  public struct EmployeeTerritory : Identifiable, SQLTableRecord, Codable {
    
    /**
     * ID structure representing the compound key of ``EmployeeTerritory``.
     */
    public struct ID : Hashable {
      
      public let employeeID : Int
      public let territoryID : String
      
      /**
       * Initialize a compound ``EmployeeTerritory`` ``ID``
       *
       * - Parameters:
       *   - employeeID: Value of ``EmployeeTerritory/employeeID``.
       *   - territoryID: Value of ``EmployeeTerritory/territoryID``.
       */
      @inlinable
      public init(_ employeeID: Int, _ territoryID: String)
      {
        self.employeeID = employeeID
        self.territoryID = territoryID
      }
    }
    
    /// Static SQL type information for the ``EmployeeTerritory`` record.
    public static let schema = Schema()
    
    /// Primary key `EmployeeID` (`INTEGER`), required (has default).
    public var employeeID : Int
    
    /// Primary key `TerritoryID` (`TEXT`), required (has default).
    public var territoryID : String
    
    /// Returns the compound primary key of ``EmployeeTerritory`` (employeeID, territoryID).
    @inlinable
    public var id : ID { ID(employeeID, territoryID) }
    
    /**
     * Initialize a new ``EmployeeTerritory`` record.
     *
     * - Parameters:
     *   - employeeID: Primary key `EmployeeID` (`INTEGER`), required (has default).
     *   - territoryID: Primary key `TerritoryID` (`TEXT`), required (has default).
     */
    @inlinable
    public init(employeeID: Int, territoryID: String)
    {
      self.employeeID = employeeID
      self.territoryID = territoryID
    }
  }
  
  /**
   * Record representing the `Order Details` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``OrderDetail`` records:
   * ```swift
   * let records = try await db.orderDetails.filter(orderBy: \.unitPrice) {
   *   $0.unitPrice != nil
   * }
   * ```
   *
   * Perform column selects on the `Order Details` table:
   * ```swift
   * let values = try await db.select(from: \.orderDetails, \.unitPrice) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``OrderDetail`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = OrderDetail.fetch(in: db, orderBy: "unitPrice", limit: 5) {
   *   $0.unitPrice != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Order Details](
   *    [OrderID]INTEGER NOT NULL,
   *    [ProductID]INTEGER NOT NULL,
   *    [UnitPrice]NUMERIC NOT NULL DEFAULT 0,
   *    [Quantity]INTEGER NOT NULL DEFAULT 1,
   *    [Discount]REAL NOT NULL DEFAULT 0,
   *     PRIMARY KEY ("OrderID","ProductID"),
   *     CHECK ([Discount]>=(0) AND [Discount]<=(1)),
   *     CHECK ([Quantity]>(0)),
   *     CHECK ([UnitPrice]>=(0)),
   *   FOREIGN KEY ([OrderID]) REFERENCES [Orders] ([OrderID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION,
   *   FOREIGN KEY ([ProductID]) REFERENCES [Products] ([ProductID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION
   * )
   * ```
   */
  public struct OrderDetail : Identifiable, SQLTableRecord, Codable {
    
    /**
     * ID structure representing the compound key of ``OrderDetail``.
     */
    public struct ID : Hashable {
      
      public let orderID : Int
      public let productID : Int
      
      /**
       * Initialize a compound ``OrderDetail`` ``ID``
       *
       * - Parameters:
       *   - orderID: Value of ``OrderDetail/orderID``.
       *   - productID: Value of ``OrderDetail/productID``.
       */
      @inlinable
      public init(_ orderID: Int, _ productID: Int)
      {
        self.orderID = orderID
        self.productID = productID
      }
    }
    
    /// Static SQL type information for the ``OrderDetail`` record.
    public static let schema = Schema()
    
    /// Primary key `OrderID` (`INTEGER`), required (has default).
    public var orderID : Int
    
    /// Primary key `ProductID` (`INTEGER`), required (has default).
    public var productID : Int
    
    /// Column `UnitPrice` (`NUMERIC`), required (has default string).
    public var unitPrice : String
    
    /// Column `Quantity` (`INTEGER`), required (default: `1`).
    public var quantity : Int
    
    /// Column `Discount` (`REAL`), required (default: `0.0`).
    public var discount : Double
    
    /// Returns the compound primary key of ``OrderDetail`` (orderID, productID).
    @inlinable
    public var id : ID { ID(orderID, productID) }
    
    /**
     * Initialize a new ``OrderDetail`` record.
     *
     * - Parameters:
     *   - orderID: Primary key `OrderID` (`INTEGER`), required (has default).
     *   - productID: Primary key `ProductID` (`INTEGER`), required (has default).
     *   - unitPrice: Column `UnitPrice` (`NUMERIC`), required (has default string).
     *   - quantity: Column `Quantity` (`INTEGER`), required (default: `1`).
     *   - discount: Column `Discount` (`REAL`), required (default: `0.0`).
     */
    @inlinable
    public init(
      orderID: Int,
      productID: Int,
      unitPrice: String = "0",
      quantity: Int = 1,
      discount: Double = 0.0
    )
    {
      self.orderID = orderID
      self.productID = productID
      self.unitPrice = unitPrice
      self.quantity = quantity
      self.discount = discount
    }
  }
  
  /**
   * Record representing the `Orders` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Order`` records:
   * ```swift
   * let records = try await db.orders.filter(orderBy: \.customerID) {
   *   $0.customerID != nil
   * }
   * ```
   *
   * Perform column selects on the `Orders` table:
   * ```swift
   * let values = try await db.select(from: \.orders, \.customerID) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Order`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Order.fetch(in: db, orderBy: "customerID", limit: 5) {
   *   $0.customerID != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Orders](
   *    [OrderID]INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
   *    [CustomerID]TEXT,
   *    [EmployeeID]INTEGER,
   *    [OrderDate]DATETIME,
   *    [RequiredDate]DATETIME,
   *    [ShippedDate]DATETIME,
   *    [ShipVia]INTEGER,
   *    [Freight]NUMERIC DEFAULT 0,
   *    [ShipName]TEXT,
   *    [ShipAddress]TEXT,
   *    [ShipCity]TEXT,
   *    [ShipRegion]TEXT,
   *    [ShipPostalCode]TEXT,
   *    [ShipCountry]TEXT,
   *    FOREIGN KEY ([EmployeeID]) REFERENCES [Employees] ([EmployeeID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION,
   *   FOREIGN KEY ([CustomerID]) REFERENCES [Customers] ([CustomerID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION,
   *   FOREIGN KEY ([ShipVia]) REFERENCES [Shippers] ([ShipperID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION
   * )
   * ```
   */
  public struct Order : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Order`` record.
    public static let schema = Schema()
    
    /// Primary key `OrderID` (`INTEGER`), required (has default).
    public var id : Int
    
    /// Column `CustomerID` (`TEXT`), optional (default: `nil`).
    public var customerID : String?
    
    /// Column `EmployeeID` (`INTEGER`), optional (default: `nil`).
    public var employeeID : Int?
    
    /// Column `OrderDate` (`DATETIME`), optional (default: `nil`).
    public var orderDate : String?
    
    /// Column `RequiredDate` (`DATETIME`), optional (default: `nil`).
    public var requiredDate : String?
    
    /// Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
    public var shippedDate : String?
    
    /// Column `ShipVia` (`INTEGER`), optional (default: `nil`).
    public var shipVia : Int?
    
    /// Column `Freight` (`NUMERIC`), optional (has default string).
    public var freight : String?
    
    /// Column `ShipName` (`TEXT`), optional (default: `nil`).
    public var shipName : String?
    
    /// Column `ShipAddress` (`TEXT`), optional (default: `nil`).
    public var shipAddress : String?
    
    /// Column `ShipCity` (`TEXT`), optional (default: `nil`).
    public var shipCity : String?
    
    /// Column `ShipRegion` (`TEXT`), optional (default: `nil`).
    public var shipRegion : String?
    
    /// Column `ShipPostalCode` (`TEXT`), optional (default: `nil`).
    public var shipPostalCode : String?
    
    /// Column `ShipCountry` (`TEXT`), optional (default: `nil`).
    public var shipCountry : String?
    
    /**
     * Initialize a new ``Order`` record.
     *
     * - Parameters:
     *   - id: Primary key `OrderID` (`INTEGER`), required (has default).
     *   - customerID: Column `CustomerID` (`TEXT`), optional (default: `nil`).
     *   - employeeID: Column `EmployeeID` (`INTEGER`), optional (default: `nil`).
     *   - orderDate: Column `OrderDate` (`DATETIME`), optional (default: `nil`).
     *   - requiredDate: Column `RequiredDate` (`DATETIME`), optional (default: `nil`).
     *   - shippedDate: Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
     *   - shipVia: Column `ShipVia` (`INTEGER`), optional (default: `nil`).
     *   - freight: Column `Freight` (`NUMERIC`), optional (has default string).
     *   - shipName: Column `ShipName` (`TEXT`), optional (default: `nil`).
     *   - shipAddress: Column `ShipAddress` (`TEXT`), optional (default: `nil`).
     *   - shipCity: Column `ShipCity` (`TEXT`), optional (default: `nil`).
     *   - shipRegion: Column `ShipRegion` (`TEXT`), optional (default: `nil`).
     *   - shipPostalCode: Column `ShipPostalCode` (`TEXT`), optional (default: `nil`).
     *   - shipCountry: Column `ShipCountry` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(
      id: Int,
      customerID: String? = nil,
      employeeID: Int? = nil,
      orderDate: String? = nil,
      requiredDate: String? = nil,
      shippedDate: String? = nil,
      shipVia: Int? = nil,
      freight: String? = "0",
      shipName: String? = nil,
      shipAddress: String? = nil,
      shipCity: String? = nil,
      shipRegion: String? = nil,
      shipPostalCode: String? = nil,
      shipCountry: String? = nil
    )
    {
      self.id = id
      self.customerID = customerID
      self.employeeID = employeeID
      self.orderDate = orderDate
      self.requiredDate = requiredDate
      self.shippedDate = shippedDate
      self.shipVia = shipVia
      self.freight = freight
      self.shipName = shipName
      self.shipAddress = shipAddress
      self.shipCity = shipCity
      self.shipRegion = shipRegion
      self.shipPostalCode = shipPostalCode
      self.shipCountry = shipCountry
    }
  }
  
  /**
   * Record representing the `Products` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Product`` records:
   * ```swift
   * let records = try await db.products.filter(orderBy: \.productName) {
   *   $0.productName != nil
   * }
   * ```
   *
   * Perform column selects on the `Products` table:
   * ```swift
   * let values = try await db.select(from: \.products, \.productName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Product`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Product.fetch(in: db, orderBy: "productName", limit: 5) {
   *   $0.productName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Products](
   *    [ProductID]INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
   *    [ProductName]TEXT NOT NULL,
   *    [SupplierID]INTEGER,
   *    [CategoryID]INTEGER,
   *    [QuantityPerUnit]TEXT,
   *    [UnitPrice]NUMERIC DEFAULT 0,
   *    [UnitsInStock]INTEGER DEFAULT 0,
   *    [UnitsOnOrder]INTEGER DEFAULT 0,
   *    [ReorderLevel]INTEGER DEFAULT 0,
   *    [Discontinued]TEXT NOT NULL DEFAULT '0',
   *     CHECK ([UnitPrice]>=(0)),
   *     CHECK ([ReorderLevel]>=(0)),
   *     CHECK ([UnitsInStock]>=(0)),
   *     CHECK ([UnitsOnOrder]>=(0)),
   *   FOREIGN KEY ([ProductID]) REFERENCES [Categories] ([CategoryID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION,
   *   FOREIGN KEY ([SupplierID]) REFERENCES [Suppliers] ([SupplierID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION
   * )
   * ```
   */
  public struct Product : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Product`` record.
    public static let schema = Schema()
    
    /// Primary key `ProductID` (`INTEGER`), required (has default).
    public var id : Int
    
    /// Column `ProductName` (`TEXT`), required (has default).
    public var productName : String
    
    /// Column `SupplierID` (`INTEGER`), optional (default: `nil`).
    public var supplierID : Int?
    
    /// Column `CategoryID` (`INTEGER`), optional (default: `nil`).
    public var categoryID : Int?
    
    /// Column `QuantityPerUnit` (`TEXT`), optional (default: `nil`).
    public var quantityPerUnit : String?
    
    /// Column `UnitPrice` (`NUMERIC`), optional (has default string).
    public var unitPrice : String?
    
    /// Column `UnitsInStock` (`INTEGER`), optional (default: `0`).
    public var unitsInStock : Int?
    
    /// Column `UnitsOnOrder` (`INTEGER`), optional (default: `0`).
    public var unitsOnOrder : Int?
    
    /// Column `ReorderLevel` (`INTEGER`), optional (default: `0`).
    public var reorderLevel : Int?
    
    /// Column `Discontinued` (`TEXT`), required (has default string).
    public var discontinued : String
    
    /**
     * Initialize a new ``Product`` record.
     *
     * - Parameters:
     *   - id: Primary key `ProductID` (`INTEGER`), required (has default).
     *   - productName: Column `ProductName` (`TEXT`), required (has default).
     *   - supplierID: Column `SupplierID` (`INTEGER`), optional (default: `nil`).
     *   - categoryID: Column `CategoryID` (`INTEGER`), optional (default: `nil`).
     *   - quantityPerUnit: Column `QuantityPerUnit` (`TEXT`), optional (default: `nil`).
     *   - unitPrice: Column `UnitPrice` (`NUMERIC`), optional (has default string).
     *   - unitsInStock: Column `UnitsInStock` (`INTEGER`), optional (default: `0`).
     *   - unitsOnOrder: Column `UnitsOnOrder` (`INTEGER`), optional (default: `0`).
     *   - reorderLevel: Column `ReorderLevel` (`INTEGER`), optional (default: `0`).
     *   - discontinued: Column `Discontinued` (`TEXT`), required (has default string).
     */
    @inlinable
    public init(
      id: Int,
      productName: String,
      supplierID: Int? = nil,
      categoryID: Int? = nil,
      quantityPerUnit: String? = nil,
      unitPrice: String? = "0",
      unitsInStock: Int? = 0,
      unitsOnOrder: Int? = 0,
      reorderLevel: Int? = 0,
      discontinued: String = "'0'"
    )
    {
      self.id = id
      self.productName = productName
      self.supplierID = supplierID
      self.categoryID = categoryID
      self.quantityPerUnit = quantityPerUnit
      self.unitPrice = unitPrice
      self.unitsInStock = unitsInStock
      self.unitsOnOrder = unitsOnOrder
      self.reorderLevel = reorderLevel
      self.discontinued = discontinued
    }
  }
  
  /**
   * Record representing the `Regions` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Region`` records:
   * ```swift
   * let records = try await db.regions.filter(orderBy: \.regionDescription) {
   *   $0.regionDescription != nil
   * }
   * ```
   *
   * Perform column selects on the `Regions` table:
   * ```swift
   * let values = try await db.select(from: \.regions, \.regionDescription) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Region`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Region.fetch(in: db, orderBy: "regionDescription", limit: 5) {
   *   $0.regionDescription != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Regions](
   *    [RegionID]INTEGER NOT NULL PRIMARY KEY,
   *    [RegionDescription]TEXT NOT NULL
   * )
   * ```
   */
  public struct Region : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Region`` record.
    public static let schema = Schema()
    
    /// Primary key `RegionID` (`INTEGER`), required (has default).
    public var id : Int
    
    /// Column `RegionDescription` (`TEXT`), required (has default).
    public var regionDescription : String
    
    /**
     * Initialize a new ``Region`` record.
     *
     * - Parameters:
     *   - id: Primary key `RegionID` (`INTEGER`), required (has default).
     *   - regionDescription: Column `RegionDescription` (`TEXT`), required (has default).
     */
    @inlinable
    public init(id: Int, regionDescription: String)
    {
      self.id = id
      self.regionDescription = regionDescription
    }
  }
  
  /**
   * Record representing the `Shippers` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Shipper`` records:
   * ```swift
   * let records = try await db.shippers.filter(orderBy: \.companyName) {
   *   $0.companyName != nil
   * }
   * ```
   *
   * Perform column selects on the `Shippers` table:
   * ```swift
   * let values = try await db.select(from: \.shippers, \.companyName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Shipper`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Shipper.fetch(in: db, orderBy: "companyName", limit: 5) {
   *   $0.companyName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Shippers](
   *    [ShipperID]INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
   *    [CompanyName]TEXT NOT NULL,
   *    [Phone]TEXT
   * )
   * ```
   */
  public struct Shipper : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Shipper`` record.
    public static let schema = Schema()
    
    /// Primary key `ShipperID` (`INTEGER`), required (has default).
    public var id : Int
    
    /// Column `CompanyName` (`TEXT`), required (has default).
    public var companyName : String
    
    /// Column `Phone` (`TEXT`), optional (default: `nil`).
    public var phone : String?
    
    /**
     * Initialize a new ``Shipper`` record.
     *
     * - Parameters:
     *   - id: Primary key `ShipperID` (`INTEGER`), required (has default).
     *   - companyName: Column `CompanyName` (`TEXT`), required (has default).
     *   - phone: Column `Phone` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(id: Int, companyName: String, phone: String? = nil)
    {
      self.id = id
      self.companyName = companyName
      self.phone = phone
    }
  }
  
  /**
   * Record representing the `Suppliers` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Supplier`` records:
   * ```swift
   * let records = try await db.suppliers.filter(orderBy: \.companyName) {
   *   $0.companyName != nil
   * }
   * ```
   *
   * Perform column selects on the `Suppliers` table:
   * ```swift
   * let values = try await db.select(from: \.suppliers, \.companyName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Supplier`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Supplier.fetch(in: db, orderBy: "companyName", limit: 5) {
   *   $0.companyName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Suppliers](
   *    [SupplierID]INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
   *    [CompanyName]TEXT NOT NULL,
   *    [ContactName]TEXT,
   *    [ContactTitle]TEXT,
   *    [Address]TEXT,
   *    [City]TEXT,
   *    [Region]TEXT,
   *    [PostalCode]TEXT,
   *    [Country]TEXT,
   *    [Phone]TEXT,
   *    [Fax]TEXT,
   *    [HomePage]TEXT
   * )
   * ```
   */
  public struct Supplier : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Supplier`` record.
    public static let schema = Schema()
    
    /// Primary key `SupplierID` (`INTEGER`), required (has default).
    public var id : Int
    
    /// Column `CompanyName` (`TEXT`), required (has default).
    public var companyName : String
    
    /// Column `ContactName` (`TEXT`), optional (default: `nil`).
    public var contactName : String?
    
    /// Column `ContactTitle` (`TEXT`), optional (default: `nil`).
    public var contactTitle : String?
    
    /// Column `Address` (`TEXT`), optional (default: `nil`).
    public var address : String?
    
    /// Column `City` (`TEXT`), optional (default: `nil`).
    public var city : String?
    
    /// Column `Region` (`TEXT`), optional (default: `nil`).
    public var region : String?
    
    /// Column `PostalCode` (`TEXT`), optional (default: `nil`).
    public var postalCode : String?
    
    /// Column `Country` (`TEXT`), optional (default: `nil`).
    public var country : String?
    
    /// Column `Phone` (`TEXT`), optional (default: `nil`).
    public var phone : String?
    
    /// Column `Fax` (`TEXT`), optional (default: `nil`).
    public var fax : String?
    
    /// Column `HomePage` (`TEXT`), optional (default: `nil`).
    public var homePage : String?
    
    /**
     * Initialize a new ``Supplier`` record.
     *
     * - Parameters:
     *   - id: Primary key `SupplierID` (`INTEGER`), required (has default).
     *   - companyName: Column `CompanyName` (`TEXT`), required (has default).
     *   - contactName: Column `ContactName` (`TEXT`), optional (default: `nil`).
     *   - contactTitle: Column `ContactTitle` (`TEXT`), optional (default: `nil`).
     *   - address: Column `Address` (`TEXT`), optional (default: `nil`).
     *   - city: Column `City` (`TEXT`), optional (default: `nil`).
     *   - region: Column `Region` (`TEXT`), optional (default: `nil`).
     *   - postalCode: Column `PostalCode` (`TEXT`), optional (default: `nil`).
     *   - country: Column `Country` (`TEXT`), optional (default: `nil`).
     *   - phone: Column `Phone` (`TEXT`), optional (default: `nil`).
     *   - fax: Column `Fax` (`TEXT`), optional (default: `nil`).
     *   - homePage: Column `HomePage` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(
      id: Int,
      companyName: String,
      contactName: String? = nil,
      contactTitle: String? = nil,
      address: String? = nil,
      city: String? = nil,
      region: String? = nil,
      postalCode: String? = nil,
      country: String? = nil,
      phone: String? = nil,
      fax: String? = nil,
      homePage: String? = nil
    )
    {
      self.id = id
      self.companyName = companyName
      self.contactName = contactName
      self.contactTitle = contactTitle
      self.address = address
      self.city = city
      self.region = region
      self.postalCode = postalCode
      self.country = country
      self.phone = phone
      self.fax = fax
      self.homePage = homePage
    }
  }
  
  /**
   * Record representing the `Territories` SQL table.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Territory`` records:
   * ```swift
   * let records = try await db.territories.filter(orderBy: \.id) {
   *   $0.id != nil
   * }
   * ```
   *
   * Perform column selects on the `Territories` table:
   * ```swift
   * let values = try await db.select(from: \.territories, \.id) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Territory`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Territory.fetch(in: db, orderBy: "id", limit: 5) {
   *   $0.id != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the table associated with the record:
   * ```sql
   * CREATE TABLE [Territories](
   *    [TerritoryID]TEXT NOT NULL,
   *    [TerritoryDescription]TEXT NOT NULL,
   *    [RegionID]INTEGER NOT NULL,
   *     PRIMARY KEY ("TerritoryID"),
   *   FOREIGN KEY ([RegionID]) REFERENCES [Regions] ([RegionID])
   *     ON DELETE NO ACTION ON UPDATE NO ACTION
   * )
   * ```
   */
  public struct Territory : Identifiable, SQLKeyedTableRecord, Codable {
    
    /// Static SQL type information for the ``Territory`` record.
    public static let schema = Schema()
    
    /// Primary key `TerritoryID` (`TEXT`), required (has default).
    public var id : String
    
    /// Column `TerritoryDescription` (`TEXT`), required (has default).
    public var territoryDescription : String
    
    /// Column `RegionID` (`INTEGER`), required (has default).
    public var regionID : Int
    
    /**
     * Initialize a new ``Territory`` record.
     *
     * - Parameters:
     *   - id: Primary key `TerritoryID` (`TEXT`), required (has default).
     *   - territoryDescription: Column `TerritoryDescription` (`TEXT`), required (has default).
     *   - regionID: Column `RegionID` (`INTEGER`), required (has default).
     */
    @inlinable
    public init(id: String, territoryDescription: String, regionID: Int)
    {
      self.id = id
      self.territoryDescription = territoryDescription
      self.regionID = regionID
    }
  }
  
  /**
   * Record representing the `Alphabetical list of products` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``AlphabeticalListOfProduct`` records:
   * ```swift
   * let records = try await db.alphabeticalListOfProducts.filter(orderBy: \.productName) {
   *   $0.productName != nil
   * }
   * ```
   *
   * Perform column selects on the `Alphabetical list of products` table:
   * ```swift
   * let values = try await db.select(from: \.alphabeticalListOfProducts, \.productName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``AlphabeticalListOfProduct`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = AlphabeticalListOfProduct.fetch(in: db, orderBy: "productName", limit: 5) {
   *   $0.productName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Alphabetical list of products]
   * AS
   * SELECT Products.*,
   *        Categories.CategoryName
   * FROM Categories
   *    INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
   * WHERE (((Products.Discontinued)=0))
   * ```
   */
  public struct AlphabeticalListOfProduct : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``AlphabeticalListOfProduct`` record.
    public static let schema = Schema()
    
    /// Column `ProductID` (`INTEGER`), optional (default: `nil`).
    public var productID : Int?
    
    /// Column `ProductName` (`TEXT`), optional (default: `nil`).
    public var productName : String?
    
    /// Column `SupplierID` (`INTEGER`), optional (default: `nil`).
    public var supplierID : Int?
    
    /// Column `CategoryID` (`INTEGER`), optional (default: `nil`).
    public var categoryID : Int?
    
    /// Column `QuantityPerUnit` (`TEXT`), optional (default: `nil`).
    public var quantityPerUnit : String?
    
    /// Column `UnitPrice` (`NUMERIC`), optional (default: `nil`).
    public var unitPrice : String?
    
    /// Column `UnitsInStock` (`INTEGER`), optional (default: `nil`).
    public var unitsInStock : Int?
    
    /// Column `UnitsOnOrder` (`INTEGER`), optional (default: `nil`).
    public var unitsOnOrder : Int?
    
    /// Column `ReorderLevel` (`INTEGER`), optional (default: `nil`).
    public var reorderLevel : Int?
    
    /// Column `Discontinued` (`TEXT`), optional (default: `nil`).
    public var discontinued : String?
    
    /// Column `CategoryName` (`TEXT`), optional (default: `nil`).
    public var categoryName : String?
    
    /**
     * Initialize a new ``AlphabeticalListOfProduct`` record.
     *
     * - Parameters:
     *   - productID: Column `ProductID` (`INTEGER`), optional (default: `nil`).
     *   - productName: Column `ProductName` (`TEXT`), optional (default: `nil`).
     *   - supplierID: Column `SupplierID` (`INTEGER`), optional (default: `nil`).
     *   - categoryID: Column `CategoryID` (`INTEGER`), optional (default: `nil`).
     *   - quantityPerUnit: Column `QuantityPerUnit` (`TEXT`), optional (default: `nil`).
     *   - unitPrice: Column `UnitPrice` (`NUMERIC`), optional (default: `nil`).
     *   - unitsInStock: Column `UnitsInStock` (`INTEGER`), optional (default: `nil`).
     *   - unitsOnOrder: Column `UnitsOnOrder` (`INTEGER`), optional (default: `nil`).
     *   - reorderLevel: Column `ReorderLevel` (`INTEGER`), optional (default: `nil`).
     *   - discontinued: Column `Discontinued` (`TEXT`), optional (default: `nil`).
     *   - categoryName: Column `CategoryName` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(
      productID: Int? = nil,
      productName: String? = nil,
      supplierID: Int? = nil,
      categoryID: Int? = nil,
      quantityPerUnit: String? = nil,
      unitPrice: String? = nil,
      unitsInStock: Int? = nil,
      unitsOnOrder: Int? = nil,
      reorderLevel: Int? = nil,
      discontinued: String? = nil,
      categoryName: String? = nil
    )
    {
      self.productID = productID
      self.productName = productName
      self.supplierID = supplierID
      self.categoryID = categoryID
      self.quantityPerUnit = quantityPerUnit
      self.unitPrice = unitPrice
      self.unitsInStock = unitsInStock
      self.unitsOnOrder = unitsOnOrder
      self.reorderLevel = reorderLevel
      self.discontinued = discontinued
      self.categoryName = categoryName
    }
  }
  
  /**
   * Record representing the `Current Product List` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``CurrentProductList`` records:
   * ```swift
   * let records = try await db.currentProductLists.filter(orderBy: \.productName) {
   *   $0.productName != nil
   * }
   * ```
   *
   * Perform column selects on the `Current Product List` table:
   * ```swift
   * let values = try await db.select(from: \.currentProductLists, \.productName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``CurrentProductList`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = CurrentProductList.fetch(in: db, orderBy: "productName", limit: 5) {
   *   $0.productName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Current Product List]
   * AS
   * SELECT ProductID,
   *        ProductName
   * FROM Products
   * WHERE Discontinued=0
   * ```
   */
  public struct CurrentProductList : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``CurrentProductList`` record.
    public static let schema = Schema()
    
    /// Column `ProductID` (`INTEGER`), optional (default: `nil`).
    public var productID : Int?
    
    /// Column `ProductName` (`TEXT`), optional (default: `nil`).
    public var productName : String?
    
    /**
     * Initialize a new ``CurrentProductList`` record.
     *
     * - Parameters:
     *   - productID: Column `ProductID` (`INTEGER`), optional (default: `nil`).
     *   - productName: Column `ProductName` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(productID: Int? = nil, productName: String? = nil)
    {
      self.productID = productID
      self.productName = productName
    }
  }
  
  /**
   * Record representing the `Customer and Suppliers by City` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``CustomerAndSuppliersByCity`` records:
   * ```swift
   * let records = try await db.customerAndSuppliersByCities.filter(orderBy: \.city) {
   *   $0.city != nil
   * }
   * ```
   *
   * Perform column selects on the `Customer and Suppliers by City` table:
   * ```swift
   * let values = try await db.select(from: \.customerAndSuppliersByCities, \.city) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``CustomerAndSuppliersByCity`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = CustomerAndSuppliersByCity.fetch(in: db, orderBy: "city", limit: 5) {
   *   $0.city != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Customer and Suppliers by City]
   * AS
   * SELECT City,
   *        CompanyName,
   *        ContactName,
   *        'Customers' AS Relationship
   * FROM Customers
   * UNION
   * SELECT City,
   *        CompanyName,
   *        ContactName,
   *        'Suppliers'
   * FROM Suppliers
   * ORDER BY City, CompanyName
   * ```
   */
  public struct CustomerAndSuppliersByCity : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``CustomerAndSuppliersByCity`` record.
    public static let schema = Schema()
    
    /// Column `City` (`TEXT`), optional (default: `nil`).
    public var city : String?
    
    /// Column `CompanyName` (`TEXT`), optional (default: `nil`).
    public var companyName : String?
    
    /// Column `ContactName` (`TEXT`), optional (default: `nil`).
    public var contactName : String?
    
    /// Column `Relationship` (`ANY`), optional (default: `nil`).
    public var relationship : String?
    
    /**
     * Initialize a new ``CustomerAndSuppliersByCity`` record.
     *
     * - Parameters:
     *   - city: Column `City` (`TEXT`), optional (default: `nil`).
     *   - companyName: Column `CompanyName` (`TEXT`), optional (default: `nil`).
     *   - contactName: Column `ContactName` (`TEXT`), optional (default: `nil`).
     *   - relationship: Column `Relationship` (`ANY`), optional (default: `nil`).
     */
    @inlinable
    public init(
      city: String? = nil,
      companyName: String? = nil,
      contactName: String? = nil,
      relationship: String? = nil
    )
    {
      self.city = city
      self.companyName = companyName
      self.contactName = contactName
      self.relationship = relationship
    }
  }
  
  /**
   * Record representing the `Invoices` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``Invoice`` records:
   * ```swift
   * let records = try await db.invoices.filter(orderBy: \.shipName) {
   *   $0.shipName != nil
   * }
   * ```
   *
   * Perform column selects on the `Invoices` table:
   * ```swift
   * let values = try await db.select(from: \.invoices, \.shipName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``Invoice`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = Invoice.fetch(in: db, orderBy: "shipName", limit: 5) {
   *   $0.shipName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Invoices]
   * AS
   * SELECT Orders.ShipName,
   *        Orders.ShipAddress,
   *        Orders.ShipCity,
   *        Orders.ShipRegion,
   *        Orders.ShipPostalCode,
   *        Orders.ShipCountry,
   *        Orders.CustomerID,
   *        Customers.CompanyName AS CustomerName,
   *        Customers.Address,
   *        Customers.City,
   *        Customers.Region,
   *        Customers.PostalCode,
   *        Customers.Country,
   *        (Employees.FirstName + ' ' + Employees.LastName) AS Salesperson,
   *        Orders.OrderID,
   *        Orders.OrderDate,
   *        Orders.RequiredDate,
   *        Orders.ShippedDate,
   *        Shippers.CompanyName As ShipperName,
   *        [Order Details].ProductID,
   *        Products.ProductName,
   *        [Order Details].UnitPrice,
   *        [Order Details].Quantity,
   *        [Order Details].Discount,
   *        ((([Order Details].UnitPrice*Quantity*(1-Discount))/100)*100) AS ExtendedPrice,
   *        Orders.Freight
   * FROM Customers
   *   JOIN Orders ON Customers.CustomerID = Orders.CustomerID
   *     JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
   *      JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
   *       JOIN Products ON Products.ProductID = [Order Details].ProductID
   *        JOIN Shippers ON Shippers.ShipperID = Orders.ShipVia
   * ```
   */
  public struct Invoice : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``Invoice`` record.
    public static let schema = Schema()
    
    /// Column `ShipName` (`TEXT`), optional (default: `nil`).
    public var shipName : String?
    
    /// Column `ShipAddress` (`TEXT`), optional (default: `nil`).
    public var shipAddress : String?
    
    /// Column `ShipCity` (`TEXT`), optional (default: `nil`).
    public var shipCity : String?
    
    /// Column `ShipRegion` (`TEXT`), optional (default: `nil`).
    public var shipRegion : String?
    
    /// Column `ShipPostalCode` (`TEXT`), optional (default: `nil`).
    public var shipPostalCode : String?
    
    /// Column `ShipCountry` (`TEXT`), optional (default: `nil`).
    public var shipCountry : String?
    
    /// Column `CustomerID` (`TEXT`), optional (default: `nil`).
    public var customerID : String?
    
    /// Column `CustomerName` (`TEXT`), optional (default: `nil`).
    public var customerName : String?
    
    /// Column `Address` (`TEXT`), optional (default: `nil`).
    public var address : String?
    
    /// Column `City` (`TEXT`), optional (default: `nil`).
    public var city : String?
    
    /// Column `Region` (`TEXT`), optional (default: `nil`).
    public var region : String?
    
    /// Column `PostalCode` (`TEXT`), optional (default: `nil`).
    public var postalCode : String?
    
    /// Column `Country` (`TEXT`), optional (default: `nil`).
    public var country : String?
    
    /// Column `Salesperson` (`ANY`), optional (default: `nil`).
    public var salesperson : String?
    
    /// Column `OrderID` (`INTEGER`), optional (default: `nil`).
    public var orderID : Int?
    
    /// Column `OrderDate` (`DATETIME`), optional (default: `nil`).
    public var orderDate : String?
    
    /// Column `RequiredDate` (`DATETIME`), optional (default: `nil`).
    public var requiredDate : String?
    
    /// Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
    public var shippedDate : String?
    
    /// Column `ShipperName` (`TEXT`), optional (default: `nil`).
    public var shipperName : String?
    
    /// Column `ProductID` (`INTEGER`), optional (default: `nil`).
    public var productID : Int?
    
    /// Column `ProductName` (`TEXT`), optional (default: `nil`).
    public var productName : String?
    
    /// Column `UnitPrice` (`NUMERIC`), optional (default: `nil`).
    public var unitPrice : String?
    
    /// Column `Quantity` (`INTEGER`), optional (default: `nil`).
    public var quantity : Int?
    
    /// Column `Discount` (`REAL`), optional (default: `nil`).
    public var discount : Double?
    
    /// Column `ExtendedPrice` (`ANY`), optional (default: `nil`).
    public var extendedPrice : String?
    
    /// Column `Freight` (`NUMERIC`), optional (default: `nil`).
    public var freight : String?
    
    /**
     * Initialize a new ``Invoice`` record.
     *
     * - Parameters:
     *   - shipName: Column `ShipName` (`TEXT`), optional (default: `nil`).
     *   - shipAddress: Column `ShipAddress` (`TEXT`), optional (default: `nil`).
     *   - shipCity: Column `ShipCity` (`TEXT`), optional (default: `nil`).
     *   - shipRegion: Column `ShipRegion` (`TEXT`), optional (default: `nil`).
     *   - shipPostalCode: Column `ShipPostalCode` (`TEXT`), optional (default: `nil`).
     *   - shipCountry: Column `ShipCountry` (`TEXT`), optional (default: `nil`).
     *   - customerID: Column `CustomerID` (`TEXT`), optional (default: `nil`).
     *   - customerName: Column `CustomerName` (`TEXT`), optional (default: `nil`).
     *   - address: Column `Address` (`TEXT`), optional (default: `nil`).
     *   - city: Column `City` (`TEXT`), optional (default: `nil`).
     *   - region: Column `Region` (`TEXT`), optional (default: `nil`).
     *   - postalCode: Column `PostalCode` (`TEXT`), optional (default: `nil`).
     *   - country: Column `Country` (`TEXT`), optional (default: `nil`).
     *   - salesperson: Column `Salesperson` (`ANY`), optional (default: `nil`).
     *   - orderID: Column `OrderID` (`INTEGER`), optional (default: `nil`).
     *   - orderDate: Column `OrderDate` (`DATETIME`), optional (default: `nil`).
     *   - requiredDate: Column `RequiredDate` (`DATETIME`), optional (default: `nil`).
     *   - shippedDate: Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
     *   - shipperName: Column `ShipperName` (`TEXT`), optional (default: `nil`).
     *   - productID: Column `ProductID` (`INTEGER`), optional (default: `nil`).
     *   - productName: Column `ProductName` (`TEXT`), optional (default: `nil`).
     *   - unitPrice: Column `UnitPrice` (`NUMERIC`), optional (default: `nil`).
     *   - quantity: Column `Quantity` (`INTEGER`), optional (default: `nil`).
     *   - discount: Column `Discount` (`REAL`), optional (default: `nil`).
     *   - extendedPrice: Column `ExtendedPrice` (`ANY`), optional (default: `nil`).
     *   - freight: Column `Freight` (`NUMERIC`), optional (default: `nil`).
     */
    @inlinable
    public init(
      shipName: String? = nil,
      shipAddress: String? = nil,
      shipCity: String? = nil,
      shipRegion: String? = nil,
      shipPostalCode: String? = nil,
      shipCountry: String? = nil,
      customerID: String? = nil,
      customerName: String? = nil,
      address: String? = nil,
      city: String? = nil,
      region: String? = nil,
      postalCode: String? = nil,
      country: String? = nil,
      salesperson: String? = nil,
      orderID: Int? = nil,
      orderDate: String? = nil,
      requiredDate: String? = nil,
      shippedDate: String? = nil,
      shipperName: String? = nil,
      productID: Int? = nil,
      productName: String? = nil,
      unitPrice: String? = nil,
      quantity: Int? = nil,
      discount: Double? = nil,
      extendedPrice: String? = nil,
      freight: String? = nil
    )
    {
      self.shipName = shipName
      self.shipAddress = shipAddress
      self.shipCity = shipCity
      self.shipRegion = shipRegion
      self.shipPostalCode = shipPostalCode
      self.shipCountry = shipCountry
      self.customerID = customerID
      self.customerName = customerName
      self.address = address
      self.city = city
      self.region = region
      self.postalCode = postalCode
      self.country = country
      self.salesperson = salesperson
      self.orderID = orderID
      self.orderDate = orderDate
      self.requiredDate = requiredDate
      self.shippedDate = shippedDate
      self.shipperName = shipperName
      self.productID = productID
      self.productName = productName
      self.unitPrice = unitPrice
      self.quantity = quantity
      self.discount = discount
      self.extendedPrice = extendedPrice
      self.freight = freight
    }
  }
  
  /**
   * Record representing the `Orders Qry` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``OrdersQry`` records:
   * ```swift
   * let records = try await db.ordersQries.filter(orderBy: \.customerID) {
   *   $0.customerID != nil
   * }
   * ```
   *
   * Perform column selects on the `Orders Qry` table:
   * ```swift
   * let values = try await db.select(from: \.ordersQries, \.customerID) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``OrdersQry`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = OrdersQry.fetch(in: db, orderBy: "customerID", limit: 5) {
   *   $0.customerID != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Orders Qry] AS
   * SELECT Orders.OrderID,
   *        Orders.CustomerID,
   *        Orders.EmployeeID,
   *        Orders.OrderDate,
   *        Orders.RequiredDate,
   *        Orders.ShippedDate,
   *        Orders.ShipVia,
   *        Orders.Freight,
   *        Orders.ShipName,
   *        Orders.ShipAddress,
   *        Orders.ShipCity,
   *        Orders.ShipRegion,
   *        Orders.ShipPostalCode,
   *        Orders.ShipCountry,
   *        Customers.CompanyName,
   *        Customers.Address,
   *        Customers.City,
   *        Customers.Region,
   *        Customers.PostalCode,
   *        Customers.Country
   * FROM Customers
   *      JOIN Orders ON Customers.CustomerID = Orders.CustomerID
   * ```
   */
  public struct OrdersQry : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``OrdersQry`` record.
    public static let schema = Schema()
    
    /// Column `OrderID` (`INTEGER`), optional (default: `nil`).
    public var orderID : Int?
    
    /// Column `CustomerID` (`TEXT`), optional (default: `nil`).
    public var customerID : String?
    
    /// Column `EmployeeID` (`INTEGER`), optional (default: `nil`).
    public var employeeID : Int?
    
    /// Column `OrderDate` (`DATETIME`), optional (default: `nil`).
    public var orderDate : String?
    
    /// Column `RequiredDate` (`DATETIME`), optional (default: `nil`).
    public var requiredDate : String?
    
    /// Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
    public var shippedDate : String?
    
    /// Column `ShipVia` (`INTEGER`), optional (default: `nil`).
    public var shipVia : Int?
    
    /// Column `Freight` (`NUMERIC`), optional (default: `nil`).
    public var freight : String?
    
    /// Column `ShipName` (`TEXT`), optional (default: `nil`).
    public var shipName : String?
    
    /// Column `ShipAddress` (`TEXT`), optional (default: `nil`).
    public var shipAddress : String?
    
    /// Column `ShipCity` (`TEXT`), optional (default: `nil`).
    public var shipCity : String?
    
    /// Column `ShipRegion` (`TEXT`), optional (default: `nil`).
    public var shipRegion : String?
    
    /// Column `ShipPostalCode` (`TEXT`), optional (default: `nil`).
    public var shipPostalCode : String?
    
    /// Column `ShipCountry` (`TEXT`), optional (default: `nil`).
    public var shipCountry : String?
    
    /// Column `CompanyName` (`TEXT`), optional (default: `nil`).
    public var companyName : String?
    
    /// Column `Address` (`TEXT`), optional (default: `nil`).
    public var address : String?
    
    /// Column `City` (`TEXT`), optional (default: `nil`).
    public var city : String?
    
    /// Column `Region` (`TEXT`), optional (default: `nil`).
    public var region : String?
    
    /// Column `PostalCode` (`TEXT`), optional (default: `nil`).
    public var postalCode : String?
    
    /// Column `Country` (`TEXT`), optional (default: `nil`).
    public var country : String?
    
    /**
     * Initialize a new ``OrdersQry`` record.
     *
     * - Parameters:
     *   - orderID: Column `OrderID` (`INTEGER`), optional (default: `nil`).
     *   - customerID: Column `CustomerID` (`TEXT`), optional (default: `nil`).
     *   - employeeID: Column `EmployeeID` (`INTEGER`), optional (default: `nil`).
     *   - orderDate: Column `OrderDate` (`DATETIME`), optional (default: `nil`).
     *   - requiredDate: Column `RequiredDate` (`DATETIME`), optional (default: `nil`).
     *   - shippedDate: Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
     *   - shipVia: Column `ShipVia` (`INTEGER`), optional (default: `nil`).
     *   - freight: Column `Freight` (`NUMERIC`), optional (default: `nil`).
     *   - shipName: Column `ShipName` (`TEXT`), optional (default: `nil`).
     *   - shipAddress: Column `ShipAddress` (`TEXT`), optional (default: `nil`).
     *   - shipCity: Column `ShipCity` (`TEXT`), optional (default: `nil`).
     *   - shipRegion: Column `ShipRegion` (`TEXT`), optional (default: `nil`).
     *   - shipPostalCode: Column `ShipPostalCode` (`TEXT`), optional (default: `nil`).
     *   - shipCountry: Column `ShipCountry` (`TEXT`), optional (default: `nil`).
     *   - companyName: Column `CompanyName` (`TEXT`), optional (default: `nil`).
     *   - address: Column `Address` (`TEXT`), optional (default: `nil`).
     *   - city: Column `City` (`TEXT`), optional (default: `nil`).
     *   - region: Column `Region` (`TEXT`), optional (default: `nil`).
     *   - postalCode: Column `PostalCode` (`TEXT`), optional (default: `nil`).
     *   - country: Column `Country` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(
      orderID: Int? = nil,
      customerID: String? = nil,
      employeeID: Int? = nil,
      orderDate: String? = nil,
      requiredDate: String? = nil,
      shippedDate: String? = nil,
      shipVia: Int? = nil,
      freight: String? = nil,
      shipName: String? = nil,
      shipAddress: String? = nil,
      shipCity: String? = nil,
      shipRegion: String? = nil,
      shipPostalCode: String? = nil,
      shipCountry: String? = nil,
      companyName: String? = nil,
      address: String? = nil,
      city: String? = nil,
      region: String? = nil,
      postalCode: String? = nil,
      country: String? = nil
    )
    {
      self.orderID = orderID
      self.customerID = customerID
      self.employeeID = employeeID
      self.orderDate = orderDate
      self.requiredDate = requiredDate
      self.shippedDate = shippedDate
      self.shipVia = shipVia
      self.freight = freight
      self.shipName = shipName
      self.shipAddress = shipAddress
      self.shipCity = shipCity
      self.shipRegion = shipRegion
      self.shipPostalCode = shipPostalCode
      self.shipCountry = shipCountry
      self.companyName = companyName
      self.address = address
      self.city = city
      self.region = region
      self.postalCode = postalCode
      self.country = country
    }
  }
  
  /**
   * Record representing the `Order Subtotals` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``OrderSubtotal`` records:
   * ```swift
   * let records = try await db.orderSubtotals.filter(orderBy: \.subtotal) {
   *   $0.subtotal != nil
   * }
   * ```
   *
   * Perform column selects on the `Order Subtotals` table:
   * ```swift
   * let values = try await db.select(from: \.orderSubtotals, \.subtotal) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``OrderSubtotal`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = OrderSubtotal.fetch(in: db, orderBy: "subtotal", limit: 5) {
   *   $0.subtotal != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Order Subtotals] AS
   * SELECT [Order Details].OrderID,
   * Sum(([Order Details].UnitPrice*Quantity*(1-Discount)/100)*100) AS Subtotal
   * FROM [Order Details]
   * GROUP BY [Order Details].OrderID
   * ```
   */
  public struct OrderSubtotal : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``OrderSubtotal`` record.
    public static let schema = Schema()
    
    /// Column `OrderID` (`INTEGER`), optional (default: `nil`).
    public var orderID : Int?
    
    /// Column `Subtotal` (`ANY`), optional (default: `nil`).
    public var subtotal : String?
    
    /**
     * Initialize a new ``OrderSubtotal`` record.
     *
     * - Parameters:
     *   - orderID: Column `OrderID` (`INTEGER`), optional (default: `nil`).
     *   - subtotal: Column `Subtotal` (`ANY`), optional (default: `nil`).
     */
    @inlinable
    public init(orderID: Int? = nil, subtotal: String? = nil)
    {
      self.orderID = orderID
      self.subtotal = subtotal
    }
  }
  
  /**
   * Record representing the `Product Sales for 1997` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``ProductSalesFor1997`` records:
   * ```swift
   * let records = try await db.productSalesFor1997s.filter(orderBy: \.categoryName) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * Perform column selects on the `Product Sales for 1997` table:
   * ```swift
   * let values = try await db.select(from: \.productSalesFor1997s, \.categoryName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``ProductSalesFor1997`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = ProductSalesFor1997.fetch(in: db, orderBy: "categoryName", limit: 5) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Product Sales for 1997] AS
   * SELECT Categories.CategoryName,
   *        Products.ProductName,
   *        Sum(([Order Details].UnitPrice*Quantity*(1-Discount)/100)*100) AS ProductSales
   * FROM Categories
   *  JOIN    Products On Categories.CategoryID = Products.CategoryID
   *     JOIN  [Order Details] on Products.ProductID = [Order Details].ProductID
   *      JOIN  [Orders] on Orders.OrderID = [Order Details].OrderID
   * WHERE Orders.ShippedDate Between DATETIME('1997-01-01') And DATETIME('1997-12-31')
   * GROUP BY Categories.CategoryName, Products.ProductName
   * ```
   */
  public struct ProductSalesFor1997 : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``ProductSalesFor1997`` record.
    public static let schema = Schema()
    
    /// Column `CategoryName` (`TEXT`), optional (default: `nil`).
    public var categoryName : String?
    
    /// Column `ProductName` (`TEXT`), optional (default: `nil`).
    public var productName : String?
    
    /// Column `ProductSales` (`ANY`), optional (default: `nil`).
    public var productSales : String?
    
    /**
     * Initialize a new ``ProductSalesFor1997`` record.
     *
     * - Parameters:
     *   - categoryName: Column `CategoryName` (`TEXT`), optional (default: `nil`).
     *   - productName: Column `ProductName` (`TEXT`), optional (default: `nil`).
     *   - productSales: Column `ProductSales` (`ANY`), optional (default: `nil`).
     */
    @inlinable
    public init(
      categoryName: String? = nil,
      productName: String? = nil,
      productSales: String? = nil
    )
    {
      self.categoryName = categoryName
      self.productName = productName
      self.productSales = productSales
    }
  }
  
  /**
   * Record representing the `Products Above Average Price` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``ProductsAboveAveragePrice`` records:
   * ```swift
   * let records = try await db.productsAboveAveragePrices.filter(orderBy: \.productName) {
   *   $0.productName != nil
   * }
   * ```
   *
   * Perform column selects on the `Products Above Average Price` table:
   * ```swift
   * let values = try await db.select(from: \.productsAboveAveragePrices, \.productName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``ProductsAboveAveragePrice`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = ProductsAboveAveragePrice.fetch(in: db, orderBy: "productName", limit: 5) {
   *   $0.productName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Products Above Average Price] AS
   * SELECT Products.ProductName,
   *        Products.UnitPrice
   * FROM Products
   * WHERE Products.UnitPrice>(SELECT AVG(UnitPrice) From Products)
   * ```
   */
  public struct ProductsAboveAveragePrice : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``ProductsAboveAveragePrice`` record.
    public static let schema = Schema()
    
    /// Column `ProductName` (`TEXT`), optional (default: `nil`).
    public var productName : String?
    
    /// Column `UnitPrice` (`NUMERIC`), optional (default: `nil`).
    public var unitPrice : String?
    
    /**
     * Initialize a new ``ProductsAboveAveragePrice`` record.
     *
     * - Parameters:
     *   - productName: Column `ProductName` (`TEXT`), optional (default: `nil`).
     *   - unitPrice: Column `UnitPrice` (`NUMERIC`), optional (default: `nil`).
     */
    @inlinable
    public init(productName: String? = nil, unitPrice: String? = nil)
    {
      self.productName = productName
      self.unitPrice = unitPrice
    }
  }
  
  /**
   * Record representing the `Products by Category` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``ProductsByCategory`` records:
   * ```swift
   * let records = try await db.productsByCategories.filter(orderBy: \.categoryName) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * Perform column selects on the `Products by Category` table:
   * ```swift
   * let values = try await db.select(from: \.productsByCategories, \.categoryName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``ProductsByCategory`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = ProductsByCategory.fetch(in: db, orderBy: "categoryName", limit: 5) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Products by Category] AS
   * SELECT Categories.CategoryName,
   *        Products.ProductName,
   *        Products.QuantityPerUnit,
   *        Products.UnitsInStock,
   *        Products.Discontinued
   * FROM Categories
   *      INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
   * WHERE Products.Discontinued <> 1
   * ```
   */
  public struct ProductsByCategory : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``ProductsByCategory`` record.
    public static let schema = Schema()
    
    /// Column `CategoryName` (`TEXT`), optional (default: `nil`).
    public var categoryName : String?
    
    /// Column `ProductName` (`TEXT`), optional (default: `nil`).
    public var productName : String?
    
    /// Column `QuantityPerUnit` (`TEXT`), optional (default: `nil`).
    public var quantityPerUnit : String?
    
    /// Column `UnitsInStock` (`INTEGER`), optional (default: `nil`).
    public var unitsInStock : Int?
    
    /// Column `Discontinued` (`TEXT`), optional (default: `nil`).
    public var discontinued : String?
    
    /**
     * Initialize a new ``ProductsByCategory`` record.
     *
     * - Parameters:
     *   - categoryName: Column `CategoryName` (`TEXT`), optional (default: `nil`).
     *   - productName: Column `ProductName` (`TEXT`), optional (default: `nil`).
     *   - quantityPerUnit: Column `QuantityPerUnit` (`TEXT`), optional (default: `nil`).
     *   - unitsInStock: Column `UnitsInStock` (`INTEGER`), optional (default: `nil`).
     *   - discontinued: Column `Discontinued` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(
      categoryName: String? = nil,
      productName: String? = nil,
      quantityPerUnit: String? = nil,
      unitsInStock: Int? = nil,
      discontinued: String? = nil
    )
    {
      self.categoryName = categoryName
      self.productName = productName
      self.quantityPerUnit = quantityPerUnit
      self.unitsInStock = unitsInStock
      self.discontinued = discontinued
    }
  }
  
  /**
   * Record representing the `Quarterly Orders` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``QuarterlyOrder`` records:
   * ```swift
   * let records = try await db.quarterlyOrders.filter(orderBy: \.customerID) {
   *   $0.customerID != nil
   * }
   * ```
   *
   * Perform column selects on the `Quarterly Orders` table:
   * ```swift
   * let values = try await db.select(from: \.quarterlyOrders, \.customerID) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``QuarterlyOrder`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = QuarterlyOrder.fetch(in: db, orderBy: "customerID", limit: 5) {
   *   $0.customerID != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Quarterly Orders] AS
   * SELECT DISTINCT Customers.CustomerID,
   *                 Customers.CompanyName,
   *                 Customers.City,
   *                 Customers.Country
   * FROM Customers
   *      JOIN Orders ON Customers.CustomerID = Orders.CustomerID
   * WHERE Orders.OrderDate BETWEEN DATETIME('1997-01-01') And DATETIME('1997-12-31')
   * ```
   */
  public struct QuarterlyOrder : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``QuarterlyOrder`` record.
    public static let schema = Schema()
    
    /// Column `CustomerID` (`TEXT`), optional (default: `nil`).
    public var customerID : String?
    
    /// Column `CompanyName` (`TEXT`), optional (default: `nil`).
    public var companyName : String?
    
    /// Column `City` (`TEXT`), optional (default: `nil`).
    public var city : String?
    
    /// Column `Country` (`TEXT`), optional (default: `nil`).
    public var country : String?
    
    /**
     * Initialize a new ``QuarterlyOrder`` record.
     *
     * - Parameters:
     *   - customerID: Column `CustomerID` (`TEXT`), optional (default: `nil`).
     *   - companyName: Column `CompanyName` (`TEXT`), optional (default: `nil`).
     *   - city: Column `City` (`TEXT`), optional (default: `nil`).
     *   - country: Column `Country` (`TEXT`), optional (default: `nil`).
     */
    @inlinable
    public init(
      customerID: String? = nil,
      companyName: String? = nil,
      city: String? = nil,
      country: String? = nil
    )
    {
      self.customerID = customerID
      self.companyName = companyName
      self.city = city
      self.country = country
    }
  }
  
  /**
   * Record representing the `Sales Totals by Amount` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``SalesTotalsByAmount`` records:
   * ```swift
   * let records = try await db.salesTotalsByAmounts.filter(orderBy: \.saleAmount) {
   *   $0.saleAmount != nil
   * }
   * ```
   *
   * Perform column selects on the `Sales Totals by Amount` table:
   * ```swift
   * let values = try await db.select(from: \.salesTotalsByAmounts, \.saleAmount) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``SalesTotalsByAmount`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = SalesTotalsByAmount.fetch(in: db, orderBy: "saleAmount", limit: 5) {
   *   $0.saleAmount != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Sales Totals by Amount] AS
   * SELECT [Order Subtotals].Subtotal AS SaleAmount,
   *                   Orders.OrderID,
   *                Customers.CompanyName,
   *                   Orders.ShippedDate
   * FROM Customers
   *  JOIN Orders ON Customers.CustomerID = Orders.CustomerID
   *     JOIN [Order Subtotals] ON Orders.OrderID = [Order Subtotals].OrderID
   * WHERE ([Order Subtotals].Subtotal >2500)
   * AND (Orders.ShippedDate BETWEEN DATETIME('1997-01-01') And DATETIME('1997-12-31'))
   * ```
   */
  public struct SalesTotalsByAmount : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``SalesTotalsByAmount`` record.
    public static let schema = Schema()
    
    /// Column `SaleAmount` (`ANY`), optional (default: `nil`).
    public var saleAmount : String?
    
    /// Column `OrderID` (`INTEGER`), optional (default: `nil`).
    public var orderID : Int?
    
    /// Column `CompanyName` (`TEXT`), optional (default: `nil`).
    public var companyName : String?
    
    /// Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
    public var shippedDate : String?
    
    /**
     * Initialize a new ``SalesTotalsByAmount`` record.
     *
     * - Parameters:
     *   - saleAmount: Column `SaleAmount` (`ANY`), optional (default: `nil`).
     *   - orderID: Column `OrderID` (`INTEGER`), optional (default: `nil`).
     *   - companyName: Column `CompanyName` (`TEXT`), optional (default: `nil`).
     *   - shippedDate: Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
     */
    @inlinable
    public init(
      saleAmount: String? = nil,
      orderID: Int? = nil,
      companyName: String? = nil,
      shippedDate: String? = nil
    )
    {
      self.saleAmount = saleAmount
      self.orderID = orderID
      self.companyName = companyName
      self.shippedDate = shippedDate
    }
  }
  
  /**
   * Record representing the `Summary of Sales by Quarter` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``SummaryOfSalesByQuarter`` records:
   * ```swift
   * let records = try await db.summaryOfSalesByQuarters.filter(orderBy: \.subtotal) {
   *   $0.subtotal != nil
   * }
   * ```
   *
   * Perform column selects on the `Summary of Sales by Quarter` table:
   * ```swift
   * let values = try await db.select(from: \.summaryOfSalesByQuarters, \.subtotal) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``SummaryOfSalesByQuarter`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = SummaryOfSalesByQuarter.fetch(in: db, orderBy: "subtotal", limit: 5) {
   *   $0.subtotal != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Summary of Sales by Quarter] AS
   * SELECT Orders.ShippedDate,
   *        Orders.OrderID,
   *        [Order Subtotals].Subtotal
   * FROM Orders
   *      INNER JOIN [Order Subtotals] ON Orders.OrderID = [Order Subtotals].OrderID
   * WHERE Orders.ShippedDate IS NOT NULL
   * ```
   */
  public struct SummaryOfSalesByQuarter : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``SummaryOfSalesByQuarter`` record.
    public static let schema = Schema()
    
    /// Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
    public var shippedDate : String?
    
    /// Column `OrderID` (`INTEGER`), optional (default: `nil`).
    public var orderID : Int?
    
    /// Column `Subtotal` (`ANY`), optional (default: `nil`).
    public var subtotal : String?
    
    /**
     * Initialize a new ``SummaryOfSalesByQuarter`` record.
     *
     * - Parameters:
     *   - shippedDate: Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
     *   - orderID: Column `OrderID` (`INTEGER`), optional (default: `nil`).
     *   - subtotal: Column `Subtotal` (`ANY`), optional (default: `nil`).
     */
    @inlinable
    public init(shippedDate: String? = nil, orderID: Int? = nil, subtotal: String? = nil)
    {
      self.shippedDate = shippedDate
      self.orderID = orderID
      self.subtotal = subtotal
    }
  }
  
  /**
   * Record representing the `Summary of Sales by Year` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``SummaryOfSalesByYear`` records:
   * ```swift
   * let records = try await db.summaryOfSalesByYears.filter(orderBy: \.subtotal) {
   *   $0.subtotal != nil
   * }
   * ```
   *
   * Perform column selects on the `Summary of Sales by Year` table:
   * ```swift
   * let values = try await db.select(from: \.summaryOfSalesByYears, \.subtotal) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``SummaryOfSalesByYear`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = SummaryOfSalesByYear.fetch(in: db, orderBy: "subtotal", limit: 5) {
   *   $0.subtotal != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Summary of Sales by Year] AS
   * SELECT      Orders.ShippedDate,
   *             Orders.OrderID,
   *  [Order Subtotals].Subtotal
   * FROM Orders
   *      INNER JOIN [Order Subtotals] ON Orders.OrderID = [Order Subtotals].OrderID
   * WHERE Orders.ShippedDate IS NOT NULL
   * ```
   */
  public struct SummaryOfSalesByYear : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``SummaryOfSalesByYear`` record.
    public static let schema = Schema()
    
    /// Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
    public var shippedDate : String?
    
    /// Column `OrderID` (`INTEGER`), optional (default: `nil`).
    public var orderID : Int?
    
    /// Column `Subtotal` (`ANY`), optional (default: `nil`).
    public var subtotal : String?
    
    /**
     * Initialize a new ``SummaryOfSalesByYear`` record.
     *
     * - Parameters:
     *   - shippedDate: Column `ShippedDate` (`DATETIME`), optional (default: `nil`).
     *   - orderID: Column `OrderID` (`INTEGER`), optional (default: `nil`).
     *   - subtotal: Column `Subtotal` (`ANY`), optional (default: `nil`).
     */
    @inlinable
    public init(shippedDate: String? = nil, orderID: Int? = nil, subtotal: String? = nil)
    {
      self.shippedDate = shippedDate
      self.orderID = orderID
      self.subtotal = subtotal
    }
  }
  
  /**
   * Record representing the `Category Sales for 1997` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``CategorySalesFor1997`` records:
   * ```swift
   * let records = try await db.categorySalesFor1997s.filter(orderBy: \.categoryName) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * Perform column selects on the `Category Sales for 1997` table:
   * ```swift
   * let values = try await db.select(from: \.categorySalesFor1997s, \.categoryName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``CategorySalesFor1997`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = CategorySalesFor1997.fetch(in: db, orderBy: "categoryName", limit: 5) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Category Sales for 1997] AS
   * SELECT     [Product Sales for 1997].CategoryName,
   *        Sum([Product Sales for 1997].ProductSales) AS CategorySales
   * FROM [Product Sales for 1997]
   * GROUP BY [Product Sales for 1997].CategoryName
   * ```
   */
  public struct CategorySalesFor1997 : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``CategorySalesFor1997`` record.
    public static let schema = Schema()
    
    /// Column `CategoryName` (`TEXT`), optional (default: `nil`).
    public var categoryName : String?
    
    /// Column `CategorySales` (`ANY`), optional (default: `nil`).
    public var categorySales : String?
    
    /**
     * Initialize a new ``CategorySalesFor1997`` record.
     *
     * - Parameters:
     *   - categoryName: Column `CategoryName` (`TEXT`), optional (default: `nil`).
     *   - categorySales: Column `CategorySales` (`ANY`), optional (default: `nil`).
     */
    @inlinable
    public init(categoryName: String? = nil, categorySales: String? = nil)
    {
      self.categoryName = categoryName
      self.categorySales = categorySales
    }
  }
  
  /**
   * Record representing the `Order Details Extended` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``OrderDetailsExtended`` records:
   * ```swift
   * let records = try await db.orderDetailsExtendeds.filter(orderBy: \.productName) {
   *   $0.productName != nil
   * }
   * ```
   *
   * Perform column selects on the `Order Details Extended` table:
   * ```swift
   * let values = try await db.select(from: \.orderDetailsExtendeds, \.productName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``OrderDetailsExtended`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = OrderDetailsExtended.fetch(in: db, orderBy: "productName", limit: 5) {
   *   $0.productName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Order Details Extended] AS
   * SELECT [Order Details].OrderID,
   *        [Order Details].ProductID,
   *        Products.ProductName,
   *      [Order Details].UnitPrice,
   *        [Order Details].Quantity,
   *        [Order Details].Discount,
   *       ([Order Details].UnitPrice*Quantity*(1-Discount)/100)*100 AS ExtendedPrice
   * FROM Products
   *      JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
   * ```
   */
  public struct OrderDetailsExtended : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``OrderDetailsExtended`` record.
    public static let schema = Schema()
    
    /// Column `OrderID` (`INTEGER`), optional (default: `nil`).
    public var orderID : Int?
    
    /// Column `ProductID` (`INTEGER`), optional (default: `nil`).
    public var productID : Int?
    
    /// Column `ProductName` (`TEXT`), optional (default: `nil`).
    public var productName : String?
    
    /// Column `UnitPrice` (`NUMERIC`), optional (default: `nil`).
    public var unitPrice : String?
    
    /// Column `Quantity` (`INTEGER`), optional (default: `nil`).
    public var quantity : Int?
    
    /// Column `Discount` (`REAL`), optional (default: `nil`).
    public var discount : Double?
    
    /// Column `ExtendedPrice` (`ANY`), optional (default: `nil`).
    public var extendedPrice : String?
    
    /**
     * Initialize a new ``OrderDetailsExtended`` record.
     *
     * - Parameters:
     *   - orderID: Column `OrderID` (`INTEGER`), optional (default: `nil`).
     *   - productID: Column `ProductID` (`INTEGER`), optional (default: `nil`).
     *   - productName: Column `ProductName` (`TEXT`), optional (default: `nil`).
     *   - unitPrice: Column `UnitPrice` (`NUMERIC`), optional (default: `nil`).
     *   - quantity: Column `Quantity` (`INTEGER`), optional (default: `nil`).
     *   - discount: Column `Discount` (`REAL`), optional (default: `nil`).
     *   - extendedPrice: Column `ExtendedPrice` (`ANY`), optional (default: `nil`).
     */
    @inlinable
    public init(
      orderID: Int? = nil,
      productID: Int? = nil,
      productName: String? = nil,
      unitPrice: String? = nil,
      quantity: Int? = nil,
      discount: Double? = nil,
      extendedPrice: String? = nil
    )
    {
      self.orderID = orderID
      self.productID = productID
      self.productName = productName
      self.unitPrice = unitPrice
      self.quantity = quantity
      self.discount = discount
      self.extendedPrice = extendedPrice
    }
  }
  
  /**
   * Record representing the `Sales by Category` SQL view.
   *
   * Record types represent rows within tables&views in a SQLite database.
   * They are returned by the functions or queries/filters generated by
   * Enlighter.
   *
   * ### Examples
   *
   * Perform record operations on ``SalesByCategory`` records:
   * ```swift
   * let records = try await db.salesByCategories.filter(orderBy: \.categoryName) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * Perform column selects on the `Sales by Category` table:
   * ```swift
   * let values = try await db.select(from: \.salesByCategories, \.categoryName) {
   *   $0.in([ 2, 3 ])
   * }
   * ```
   *
   * Perform low level operations on ``SalesByCategory`` records:
   * ```swift
   * var db : OpaquePointer?
   * sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil)
   *
   * let records = SalesByCategory.fetch(in: db, orderBy: "categoryName", limit: 5) {
   *   $0.categoryName != nil
   * }
   * ```
   *
   * ### SQL
   *
   * The SQL used to create the view associated with the record:
   * ```sql
   * CREATE VIEW [Sales by Category] AS
   * SELECT Categories.CategoryID,
   *        Categories.CategoryName,
   *          Products.ProductName,
   *   Sum([Order Details Extended].ExtendedPrice) AS ProductSales
   * FROM  Categories
   *     JOIN Products
   *       ON Categories.CategoryID = Products.CategoryID
   *        JOIN [Order Details Extended]
   *          ON Products.ProductID = [Order Details Extended].ProductID
   *            JOIN Orders
   *              ON Orders.OrderID = [Order Details Extended].OrderID
   * WHERE Orders.OrderDate BETWEEN DATETIME('1997-01-01') And DATETIME('1997-12-31')
   * GROUP BY Categories.CategoryID, Categories.CategoryName, Products.ProductName
   * ```
   */
  public struct SalesByCategory : SQLViewRecord, Codable {
    
    /// Static SQL type information for the ``SalesByCategory`` record.
    public static let schema = Schema()
    
    /// Column `CategoryID` (`INTEGER`), optional (default: `nil`).
    public var categoryID : Int?
    
    /// Column `CategoryName` (`TEXT`), optional (default: `nil`).
    public var categoryName : String?
    
    /// Column `ProductName` (`TEXT`), optional (default: `nil`).
    public var productName : String?
    
    /// Column `ProductSales` (`ANY`), optional (default: `nil`).
    public var productSales : String?
    
    /**
     * Initialize a new ``SalesByCategory`` record.
     *
     * - Parameters:
     *   - categoryID: Column `CategoryID` (`INTEGER`), optional (default: `nil`).
     *   - categoryName: Column `CategoryName` (`TEXT`), optional (default: `nil`).
     *   - productName: Column `ProductName` (`TEXT`), optional (default: `nil`).
     *   - productSales: Column `ProductSales` (`ANY`), optional (default: `nil`).
     */
    @inlinable
    public init(
      categoryID: Int? = nil,
      categoryName: String? = nil,
      productName: String? = nil,
      productSales: String? = nil
    )
    {
      self.categoryID = categoryID
      self.categoryName = categoryName
      self.productName = productName
      self.productSales = productSales
    }
  }
  
  /// Property based access to the ``RecordTypes-swift.struct``.
  public static let recordTypes = RecordTypes()
  
  #if swift(>=5.7)
  /// All RecordTypes defined in the database.
  public static let _allRecordTypes : [ any SQLRecord.Type ] = [ Category.self, CustomerCustomerDemo.self, CustomerDemographic.self, Customer.self, Employee.self, EmployeeTerritory.self, OrderDetail.self, Order.self, Product.self, Region.self, Shipper.self, Supplier.self, Territory.self, AlphabeticalListOfProduct.self, CurrentProductList.self, CustomerAndSuppliersByCity.self, Invoice.self, OrdersQry.self, OrderSubtotal.self, ProductSalesFor1997.self, ProductsAboveAveragePrice.self, ProductsByCategory.self, QuarterlyOrder.self, SalesTotalsByAmount.self, SummaryOfSalesByQuarter.self, SummaryOfSalesByYear.self, CategorySalesFor1997.self, OrderDetailsExtended.self, SalesByCategory.self ]
  #endif // swift(>=5.7)
  
  /// User version of the database (`PRAGMA user_version`).
  public static var userVersion = 0
  
  /// Whether `INSERT … RETURNING` should be used (requires SQLite 3.35.0+).
  public static var useInsertReturning = sqlite3_libversion_number() >= 3035000
  
  public static func withOptCString<R>(
    _ s: String?,
    _ body: ( UnsafePointer<CChar>? ) throws -> R
  ) rethrows -> R
  {
    if let s = s { return try s.withCString(body) }
    else { return try body(nil) }
  }
  
  public static func withOptBlob<R>(
    _ data: [ UInt8 ]?,
    _ body: ( UnsafeRawBufferPointer ) throws -> R
  ) rethrows -> R
  {
    if let data = data { return try data.withUnsafeBytes(body) }
    else { return try body(UnsafeRawBufferPointer(start: nil, count: 0)) }
  }
  
  /// The `connectionHandler` is used to open SQLite database connections.
  public var connectionHandler : SQLConnectionHandler
  
  /**
   * Initialize ``NorthwindLighter``, read-only, with a `URL`.
   *
   * Configures the database with a simple connection pool opening the
   * specified `URL` read-only.
   *
   * Example:
   * ```swift
   * let db = NorthwindLighter(url: ...)
   *
   * // Write operations will raise an error.
   * let readOnly = NorthwindLighter(
   *   url: Bundle.module.url(forResource: "samples", withExtension: "db")
   * )
   * ```
   *
   * - Parameters:
   *   - url: A `URL` pointing to the database to be used.
   */
  @inlinable
  public init(url: URL)
  {
    self.connectionHandler = .simplePool(url: url, readOnly: true)
  }
  
  /**
   * Initialize ``NorthwindLighter``, read-only, with a `URL`.
   *
   * Configures the database with a simple connection pool opening the
   * specified `URL` read-only.
   *
   * Example:
   * ```swift
   * let db = NorthwindLighter(url: ...)
   *
   * // Write operations will raise an error.
   * let readOnly = NorthwindLighter(
   *   url: Bundle.module.url(forResource: "samples", withExtension: "db")
   * )
   * ```
   *
   * - Parameters:
   *   - url: A `URL` pointing to the database to be used.
   *   - readOnly: For protocol conformance, only allowed value: `true`.
   */
  @inlinable
  public init(url: URL, readOnly: Bool = true)
  {
    self.init(url: url)
  }
  
  /**
   * Initialize ``NorthwindLighter`` w/ a `SQLConnectionHandler`.
   *
   * `SQLConnectionHandler`'s are used to open SQLite database connections when
   * queries are run using the `Lighter` APIs.
   * The `SQLConnectionHandler` is a protocol and custom handlers
   * can be provided.
   *
   * Example:
   * ```swift
   * let db = NorthwindLighter(connectionHandler: .simplePool(
   *   url: Bundle.module.url(forResource: "samples", withExtension: "db"),
   *   readOnly: true,
   *   maxAge: 10,
   *   maximumPoolSizePerConfiguration: 4
   * ))
   * ```
   *
   * - Parameters:
   *   - connectionHandler: The `SQLConnectionHandler` to use w/ the database.
   */
  @inlinable
  public init(connectionHandler: SQLConnectionHandler)
  {
    self.connectionHandler = connectionHandler
  }
}

public extension NorthwindLighter.Category {
  
  /**
   * Fetch ``Category`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Category.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Categories"#
   * }
   *
   * let records = Category.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Categories"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Category`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Category ]?
  {
    var sql = customSQL ?? NorthwindLighter.Category.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Category ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Category(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.CustomerCustomerDemo {
  
  /**
   * Fetch ``CustomerCustomerDemo`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = CustomerCustomerDemo.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM CustomerCustomerDemo"#
   * }
   *
   * let records = CustomerCustomerDemo.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM CustomerCustomerDemo"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``CustomerCustomerDemo`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.CustomerCustomerDemo ]?
  {
    var sql = customSQL ?? NorthwindLighter.CustomerCustomerDemo.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.CustomerCustomerDemo ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.CustomerCustomerDemo(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.CustomerDemographic {
  
  /**
   * Fetch ``CustomerDemographic`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = CustomerDemographic.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM CustomerDemographics"#
   * }
   *
   * let records = CustomerDemographic.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM CustomerDemographics"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``CustomerDemographic`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.CustomerDemographic ]?
  {
    var sql = customSQL ?? NorthwindLighter.CustomerDemographic.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.CustomerDemographic ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.CustomerDemographic(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.Customer {
  
  /**
   * Fetch ``Customer`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Customer.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Customers"#
   * }
   *
   * let records = Customer.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Customers"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Customer`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Customer ]?
  {
    var sql = customSQL ?? NorthwindLighter.Customer.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Customer ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Customer(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.Employee {
  
  /**
   * Fetch ``Employee`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Employee.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Employees"#
   * }
   *
   * let records = Employee.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Employees"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Employee`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Employee ]?
  {
    var sql = customSQL ?? NorthwindLighter.Employee.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Employee ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Employee(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.EmployeeTerritory {
  
  /**
   * Fetch ``EmployeeTerritory`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = EmployeeTerritory.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM EmployeeTerritories"#
   * }
   *
   * let records = EmployeeTerritory.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM EmployeeTerritories"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``EmployeeTerritory`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.EmployeeTerritory ]?
  {
    var sql = customSQL ?? NorthwindLighter.EmployeeTerritory.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.EmployeeTerritory ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.EmployeeTerritory(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.OrderDetail {
  
  /**
   * Fetch ``OrderDetail`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = OrderDetail.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Order Details"#
   * }
   *
   * let records = OrderDetail.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Order Details"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``OrderDetail`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.OrderDetail ]?
  {
    var sql = customSQL ?? NorthwindLighter.OrderDetail.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.OrderDetail ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.OrderDetail(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.Order {
  
  /**
   * Fetch ``Order`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Order.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Orders"#
   * }
   *
   * let records = Order.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Orders"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Order`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Order ]?
  {
    var sql = customSQL ?? NorthwindLighter.Order.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Order ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Order(statement, indices: indices))
    }
    return records
  }
  
  /**
   * Fetch a ``Order`` record the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * if let record = Order.find(10, in: db) {
   *   print("Found record:", record)
   * }
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Optional custom SQL yielding ``Order`` records, has one `?` parameter containing the ID.
   *   - primaryKey: The primary key value to lookup (e.g. `10`)
   * - Returns: The record matching the query, or `nil` if it wasn't found or there was an error.
   */
  @inlinable
  static func find(
    _ primaryKey: Int,
    `in` db: OpaquePointer!,
    sql customSQL: String? = nil
  ) -> NorthwindLighter.Order?
  {
    var sql = customSQL ?? NorthwindLighter.Order.Schema.select
    if customSQL != nil {
      sql.append(#" WHERE "OrderID" = ? LIMIT 1"#)
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    sqlite3_bind_int64(statement, 1, Int64(primaryKey))
    let rc = sqlite3_step(statement)
    if rc == SQLITE_DONE {
      return nil
    }
    else if rc != SQLITE_ROW {
      return nil
    }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    return NorthwindLighter.Order(statement, indices: indices)
  }
}

public extension NorthwindLighter.Product {
  
  /**
   * Fetch ``Product`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Product.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Products"#
   * }
   *
   * let records = Product.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Products"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Product`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Product ]?
  {
    var sql = customSQL ?? NorthwindLighter.Product.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Product ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Product(statement, indices: indices))
    }
    return records
  }
  
  /**
   * Fetch a ``Product`` record the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * if let record = Product.find(10, in: db) {
   *   print("Found record:", record)
   * }
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Optional custom SQL yielding ``Product`` records, has one `?` parameter containing the ID.
   *   - primaryKey: The primary key value to lookup (e.g. `10`)
   * - Returns: The record matching the query, or `nil` if it wasn't found or there was an error.
   */
  @inlinable
  static func find(
    _ primaryKey: Int,
    `in` db: OpaquePointer!,
    sql customSQL: String? = nil
  ) -> NorthwindLighter.Product?
  {
    var sql = customSQL ?? NorthwindLighter.Product.Schema.select
    if customSQL != nil {
      sql.append(#" WHERE "ProductID" = ? LIMIT 1"#)
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    sqlite3_bind_int64(statement, 1, Int64(primaryKey))
    let rc = sqlite3_step(statement)
    if rc == SQLITE_DONE {
      return nil
    }
    else if rc != SQLITE_ROW {
      return nil
    }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    return NorthwindLighter.Product(statement, indices: indices)
  }
}

public extension NorthwindLighter.Region {
  
  /**
   * Fetch ``Region`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Region.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Regions"#
   * }
   *
   * let records = Region.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Regions"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Region`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Region ]?
  {
    var sql = customSQL ?? NorthwindLighter.Region.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Region ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Region(statement, indices: indices))
    }
    return records
  }
  
  /**
   * Fetch a ``Region`` record the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * if let record = Region.find(10, in: db) {
   *   print("Found record:", record)
   * }
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Optional custom SQL yielding ``Region`` records, has one `?` parameter containing the ID.
   *   - primaryKey: The primary key value to lookup (e.g. `10`)
   * - Returns: The record matching the query, or `nil` if it wasn't found or there was an error.
   */
  @inlinable
  static func find(
    _ primaryKey: Int,
    `in` db: OpaquePointer!,
    sql customSQL: String? = nil
  ) -> NorthwindLighter.Region?
  {
    var sql = customSQL ?? NorthwindLighter.Region.Schema.select
    if customSQL != nil {
      sql.append(#" WHERE "RegionID" = ? LIMIT 1"#)
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    sqlite3_bind_int64(statement, 1, Int64(primaryKey))
    let rc = sqlite3_step(statement)
    if rc == SQLITE_DONE {
      return nil
    }
    else if rc != SQLITE_ROW {
      return nil
    }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    return NorthwindLighter.Region(statement, indices: indices)
  }
}

public extension NorthwindLighter.Shipper {
  
  /**
   * Fetch ``Shipper`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Shipper.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Shippers"#
   * }
   *
   * let records = Shipper.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Shippers"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Shipper`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Shipper ]?
  {
    var sql = customSQL ?? NorthwindLighter.Shipper.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Shipper ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Shipper(statement, indices: indices))
    }
    return records
  }
  
  /**
   * Fetch a ``Shipper`` record the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * if let record = Shipper.find(10, in: db) {
   *   print("Found record:", record)
   * }
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Optional custom SQL yielding ``Shipper`` records, has one `?` parameter containing the ID.
   *   - primaryKey: The primary key value to lookup (e.g. `10`)
   * - Returns: The record matching the query, or `nil` if it wasn't found or there was an error.
   */
  @inlinable
  static func find(
    _ primaryKey: Int,
    `in` db: OpaquePointer!,
    sql customSQL: String? = nil
  ) -> NorthwindLighter.Shipper?
  {
    var sql = customSQL ?? NorthwindLighter.Shipper.Schema.select
    if customSQL != nil {
      sql.append(#" WHERE "ShipperID" = ? LIMIT 1"#)
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    sqlite3_bind_int64(statement, 1, Int64(primaryKey))
    let rc = sqlite3_step(statement)
    if rc == SQLITE_DONE {
      return nil
    }
    else if rc != SQLITE_ROW {
      return nil
    }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    return NorthwindLighter.Shipper(statement, indices: indices)
  }
}

public extension NorthwindLighter.Supplier {
  
  /**
   * Fetch ``Supplier`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Supplier.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Suppliers"#
   * }
   *
   * let records = Supplier.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Suppliers"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Supplier`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Supplier ]?
  {
    var sql = customSQL ?? NorthwindLighter.Supplier.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Supplier ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Supplier(statement, indices: indices))
    }
    return records
  }
  
  /**
   * Fetch a ``Supplier`` record the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * if let record = Supplier.find(10, in: db) {
   *   print("Found record:", record)
   * }
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Optional custom SQL yielding ``Supplier`` records, has one `?` parameter containing the ID.
   *   - primaryKey: The primary key value to lookup (e.g. `10`)
   * - Returns: The record matching the query, or `nil` if it wasn't found or there was an error.
   */
  @inlinable
  static func find(
    _ primaryKey: Int,
    `in` db: OpaquePointer!,
    sql customSQL: String? = nil
  ) -> NorthwindLighter.Supplier?
  {
    var sql = customSQL ?? NorthwindLighter.Supplier.Schema.select
    if customSQL != nil {
      sql.append(#" WHERE "SupplierID" = ? LIMIT 1"#)
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    sqlite3_bind_int64(statement, 1, Int64(primaryKey))
    let rc = sqlite3_step(statement)
    if rc == SQLITE_DONE {
      return nil
    }
    else if rc != SQLITE_ROW {
      return nil
    }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    return NorthwindLighter.Supplier(statement, indices: indices)
  }
}

public extension NorthwindLighter.Territory {
  
  /**
   * Fetch ``Territory`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Territory.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Territories"#
   * }
   *
   * let records = Territory.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Territories"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Territory`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Territory ]?
  {
    var sql = customSQL ?? NorthwindLighter.Territory.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Territory ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Territory(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.AlphabeticalListOfProduct {
  
  /**
   * Fetch ``AlphabeticalListOfProduct`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = AlphabeticalListOfProduct.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Alphabetical list of products"#
   * }
   *
   * let records = AlphabeticalListOfProduct.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Alphabetical list of products"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``AlphabeticalListOfProduct`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.AlphabeticalListOfProduct ]?
  {
    var sql = customSQL ?? NorthwindLighter.AlphabeticalListOfProduct.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.AlphabeticalListOfProduct ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.AlphabeticalListOfProduct(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.CurrentProductList {
  
  /**
   * Fetch ``CurrentProductList`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = CurrentProductList.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Current Product List"#
   * }
   *
   * let records = CurrentProductList.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Current Product List"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``CurrentProductList`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.CurrentProductList ]?
  {
    var sql = customSQL ?? NorthwindLighter.CurrentProductList.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.CurrentProductList ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.CurrentProductList(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.CustomerAndSuppliersByCity {
  
  /**
   * Fetch ``CustomerAndSuppliersByCity`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = CustomerAndSuppliersByCity.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Customer and Suppliers by City"#
   * }
   *
   * let records = CustomerAndSuppliersByCity.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Customer and Suppliers by City"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``CustomerAndSuppliersByCity`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.CustomerAndSuppliersByCity ]?
  {
    var sql = customSQL ?? NorthwindLighter.CustomerAndSuppliersByCity.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.CustomerAndSuppliersByCity ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.CustomerAndSuppliersByCity(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.Invoice {
  
  /**
   * Fetch ``Invoice`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = Invoice.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Invoices"#
   * }
   *
   * let records = Invoice.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Invoices"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``Invoice`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.Invoice ]?
  {
    var sql = customSQL ?? NorthwindLighter.Invoice.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.Invoice ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.Invoice(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.OrdersQry {
  
  /**
   * Fetch ``OrdersQry`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = OrdersQry.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Orders Qry"#
   * }
   *
   * let records = OrdersQry.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Orders Qry"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``OrdersQry`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.OrdersQry ]?
  {
    var sql = customSQL ?? NorthwindLighter.OrdersQry.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.OrdersQry ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.OrdersQry(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.OrderSubtotal {
  
  /**
   * Fetch ``OrderSubtotal`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = OrderSubtotal.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Order Subtotals"#
   * }
   *
   * let records = OrderSubtotal.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Order Subtotals"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``OrderSubtotal`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.OrderSubtotal ]?
  {
    var sql = customSQL ?? NorthwindLighter.OrderSubtotal.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.OrderSubtotal ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.OrderSubtotal(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.ProductSalesFor1997 {
  
  /**
   * Fetch ``ProductSalesFor1997`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = ProductSalesFor1997.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Product Sales for 1997"#
   * }
   *
   * let records = ProductSalesFor1997.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Product Sales for 1997"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``ProductSalesFor1997`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.ProductSalesFor1997 ]?
  {
    var sql = customSQL ?? NorthwindLighter.ProductSalesFor1997.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.ProductSalesFor1997 ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.ProductSalesFor1997(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.ProductsAboveAveragePrice {
  
  /**
   * Fetch ``ProductsAboveAveragePrice`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = ProductsAboveAveragePrice.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Products Above Average Price"#
   * }
   *
   * let records = ProductsAboveAveragePrice.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Products Above Average Price"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``ProductsAboveAveragePrice`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.ProductsAboveAveragePrice ]?
  {
    var sql = customSQL ?? NorthwindLighter.ProductsAboveAveragePrice.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.ProductsAboveAveragePrice ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.ProductsAboveAveragePrice(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.ProductsByCategory {
  
  /**
   * Fetch ``ProductsByCategory`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = ProductsByCategory.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Products by Category"#
   * }
   *
   * let records = ProductsByCategory.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Products by Category"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``ProductsByCategory`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.ProductsByCategory ]?
  {
    var sql = customSQL ?? NorthwindLighter.ProductsByCategory.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.ProductsByCategory ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.ProductsByCategory(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.QuarterlyOrder {
  
  /**
   * Fetch ``QuarterlyOrder`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = QuarterlyOrder.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Quarterly Orders"#
   * }
   *
   * let records = QuarterlyOrder.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Quarterly Orders"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``QuarterlyOrder`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.QuarterlyOrder ]?
  {
    var sql = customSQL ?? NorthwindLighter.QuarterlyOrder.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.QuarterlyOrder ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.QuarterlyOrder(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.SalesTotalsByAmount {
  
  /**
   * Fetch ``SalesTotalsByAmount`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = SalesTotalsByAmount.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Sales Totals by Amount"#
   * }
   *
   * let records = SalesTotalsByAmount.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Sales Totals by Amount"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``SalesTotalsByAmount`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.SalesTotalsByAmount ]?
  {
    var sql = customSQL ?? NorthwindLighter.SalesTotalsByAmount.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.SalesTotalsByAmount ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.SalesTotalsByAmount(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.SummaryOfSalesByQuarter {
  
  /**
   * Fetch ``SummaryOfSalesByQuarter`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = SummaryOfSalesByQuarter.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Summary of Sales by Quarter"#
   * }
   *
   * let records = SummaryOfSalesByQuarter.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Summary of Sales by Quarter"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``SummaryOfSalesByQuarter`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.SummaryOfSalesByQuarter ]?
  {
    var sql = customSQL ?? NorthwindLighter.SummaryOfSalesByQuarter.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.SummaryOfSalesByQuarter ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.SummaryOfSalesByQuarter(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.SummaryOfSalesByYear {
  
  /**
   * Fetch ``SummaryOfSalesByYear`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = SummaryOfSalesByYear.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Summary of Sales by Year"#
   * }
   *
   * let records = SummaryOfSalesByYear.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Summary of Sales by Year"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``SummaryOfSalesByYear`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.SummaryOfSalesByYear ]?
  {
    var sql = customSQL ?? NorthwindLighter.SummaryOfSalesByYear.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.SummaryOfSalesByYear ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.SummaryOfSalesByYear(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.CategorySalesFor1997 {
  
  /**
   * Fetch ``CategorySalesFor1997`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = CategorySalesFor1997.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Category Sales for 1997"#
   * }
   *
   * let records = CategorySalesFor1997.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Category Sales for 1997"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``CategorySalesFor1997`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.CategorySalesFor1997 ]?
  {
    var sql = customSQL ?? NorthwindLighter.CategorySalesFor1997.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.CategorySalesFor1997 ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.CategorySalesFor1997(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.OrderDetailsExtended {
  
  /**
   * Fetch ``OrderDetailsExtended`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = OrderDetailsExtended.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Order Details Extended"#
   * }
   *
   * let records = OrderDetailsExtended.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Order Details Extended"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``OrderDetailsExtended`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.OrderDetailsExtended ]?
  {
    var sql = customSQL ?? NorthwindLighter.OrderDetailsExtended.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.OrderDetailsExtended ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(
        NorthwindLighter.OrderDetailsExtended(statement, indices: indices)
      )
    }
    return records
  }
}

public extension NorthwindLighter.SalesByCategory {
  
  /**
   * Fetch ``SalesByCategory`` records using the base SQLite API.
   *
   * If the function returns `nil`, the error can be found using the usual
   * `sqlite3_errcode` and companions.
   *
   * Example:
   * ```swift
   * let records = SalesByCategory.fetch(
   *   from : db,
   *   sql  : #"SELECT * FROM Sales by Category"#
   * }
   *
   * let records = SalesByCategory.fetch(
   *   from    : db,
   *   sql     : #"SELECT * FROM Sales by Category"#,
   *   orderBy : "name", limit: 5
   * )
   * ```
   *
   * - Parameters:
   *   - db: The SQLite database handle (as returned by `sqlite3_open`)
   *   - sql: Custom SQL yielding ``SalesByCategory`` records.
   *   - orderBySQL: If set, some SQL that is added as an `ORDER BY` clause (e.g. `name DESC`).
   *   - limit: An optional fetch limit.
   * - Returns: The records matching the query, or `nil` if there was an error.
   */
  @inlinable
  static func fetch(
    from db: OpaquePointer!,
    sql customSQL: String? = nil,
    orderBy orderBySQL: String? = nil,
    limit: Int? = nil
  ) -> [ NorthwindLighter.SalesByCategory ]?
  {
    var sql = customSQL ?? NorthwindLighter.SalesByCategory.Schema.select
    if let orderBySQL = orderBySQL {
      sql.append(" ORDER BY \(orderBySQL)")
    }
    if let limit = limit {
      sql.append(" LIMIT \(limit)")
    }
    var handle : OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &handle, nil) == SQLITE_OK,
          let statement = handle else { return nil }
    defer { sqlite3_finalize(statement) }
    let indices = customSQL != nil ? Schema.lookupColumnIndices(in: statement) : Schema.selectColumnIndices
    var records = [ NorthwindLighter.SalesByCategory ]()
    while true {
      let rc = sqlite3_step(statement)
      if rc == SQLITE_DONE {
        break
      }
      else if rc != SQLITE_ROW {
        return nil
      }
      records.append(NorthwindLighter.SalesByCategory(statement, indices: indices))
    }
    return records
  }
}

public extension NorthwindLighter.Category {
  
  /**
   * Static type information for the ``Category`` record (`Categories` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_categoryName: Int32, idx_description: Int32, idx_picture: Int32 )
    public typealias RecordType = NorthwindLighter.Category
    
    /// The SQL table name associated with the ``Category`` record.
    public static let externalName = "Categories"
    
    /// The number of columns the `Categories` table has.
    public static let columnCount : Int32 = 4
    
    /// Information on the records primary key (``Category/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.Category, Int?>(
      externalName: "CategoryID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Category.id
    )
    
    /// SQL to `SELECT` all columns of the `Categories` table.
    public static let select = #"SELECT "CategoryID", "CategoryName", "Description", "Picture" FROM "Categories""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CategoryID", "CategoryName", "Description", "Picture""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Categories_id FROM Categories`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Categories_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CategoryID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "CategoryName") == 0 {
          indices.idx_categoryName = i
        }
        else if strcmp(col!, "Description") == 0 {
          indices.idx_description = i
        }
        else if strcmp(col!, "Picture") == 0 {
          indices.idx_picture = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Category/id`` (`CategoryID` column).
    public let id = MappedColumn<NorthwindLighter.Category, Int?>(
      externalName: "CategoryID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Category.id
    )
    
    /// Type information for property ``Category/categoryName`` (`CategoryName` column).
    public let categoryName = MappedColumn<NorthwindLighter.Category, String?>(
      externalName: "CategoryName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Category.categoryName
    )
    
    /// Type information for property ``Category/description`` (`Description` column).
    public let description = MappedColumn<NorthwindLighter.Category, String?>(
      externalName: "Description",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Category.description
    )
    
    /// Type information for property ``Category/picture`` (`Picture` column).
    public let picture = MappedColumn<NorthwindLighter.Category, [ UInt8 ]?>(
      externalName: "Picture",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Category.picture
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, categoryName, description, picture ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Category`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Categories", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Category(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: (indices.idx_id >= 0) && (indices.idx_id < argc) ? (sqlite3_column_type(statement, indices.idx_id) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_id)) : nil) : Self.schema.id.defaultValue,
      categoryName: (indices.idx_categoryName >= 0) && (indices.idx_categoryName < argc) ? (sqlite3_column_text(statement, indices.idx_categoryName).flatMap(String.init(cString:))) : Self.schema.categoryName.defaultValue,
      description: (indices.idx_description >= 0) && (indices.idx_description < argc) ? (sqlite3_column_text(statement, indices.idx_description).flatMap(String.init(cString:))) : Self.schema.description.defaultValue,
      picture: (indices.idx_picture >= 0) && (indices.idx_picture < argc) ? (sqlite3_column_blob(statement, indices.idx_picture).flatMap({ [ UInt8 ](UnsafeRawBufferPointer(start: $0, count: Int(sqlite3_column_bytes(statement, indices.idx_picture)))) })) : Self.schema.picture.defaultValue
    )
  }
  
  /**
   * Bind all ``Category`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Categories" SET "CategoryName" = ?, "Description" = ?, "Picture" = ? WHERE "CategoryID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Category(id: 1, categoryName: "Hello", description: "World", picture: nil)
   * let ok = record.bind(to: statement, indices: ( 4, 1, 2, 3 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_id >= 0 {
      if let id = id {
        sqlite3_bind_int64(statement, indices.idx_id, Int64(id))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_id)
      }
    }
    return try NorthwindLighter.withOptCString(categoryName) { ( s ) in
      if indices.idx_categoryName >= 0 {
        sqlite3_bind_text(statement, indices.idx_categoryName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(description) { ( s ) in
        if indices.idx_description >= 0 {
          sqlite3_bind_text(statement, indices.idx_description, s, -1, nil)
        }
        return try NorthwindLighter.withOptBlob(picture) { ( rbp ) in
          if indices.idx_picture >= 0 {
            sqlite3_bind_blob(
              statement,
              indices.idx_picture,
              rbp.baseAddress,
              Int32(rbp.count),
              nil
            )
          }
          return try execute()
        }
      }
    }
  }
}

public extension NorthwindLighter.CustomerCustomerDemo {
  
  /**
   * Static type information for the ``CustomerCustomerDemo`` record (`CustomerCustomerDemo` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLTableSchema {
    
    public typealias PropertyIndices = ( idx_customerID: Int32, idx_customerTypeID: Int32 )
    public typealias RecordType = NorthwindLighter.CustomerCustomerDemo
    
    /// The SQL table name associated with the ``CustomerCustomerDemo`` record.
    public static let externalName = "CustomerCustomerDemo"
    
    /// The number of columns the `CustomerCustomerDemo` table has.
    public static let columnCount : Int32 = 2
    
    /// SQL to `SELECT` all columns of the `CustomerCustomerDemo` table.
    public static let select = #"SELECT "CustomerID", "CustomerTypeID" FROM "CustomerCustomerDemo""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CustomerID", "CustomerTypeID""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, CustomerCustomerDemo_id FROM CustomerCustomerDemo`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `CustomerCustomerDemo_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CustomerID") == 0 {
          indices.idx_customerID = i
        }
        else if strcmp(col!, "CustomerTypeID") == 0 {
          indices.idx_customerTypeID = i
        }
      }
      return indices
    }
    
    /// Type information for property ``CustomerCustomerDemo/customerID`` (`CustomerID` column).
    public let customerID = MappedForeignKey<NorthwindLighter.CustomerCustomerDemo, String, MappedColumn<NorthwindLighter.Customer, String?>>(
      externalName: "CustomerID",
      defaultValue: "",
      keyPath: \NorthwindLighter.CustomerCustomerDemo.customerID,
      destinationColumn: NorthwindLighter.Customer.schema.id
    )
    
    /// Type information for property ``CustomerCustomerDemo/customerTypeID`` (`CustomerTypeID` column).
    public let customerTypeID = MappedForeignKey<NorthwindLighter.CustomerCustomerDemo, String, MappedColumn<NorthwindLighter.CustomerDemographic, String>>(
      externalName: "CustomerTypeID",
      defaultValue: "",
      keyPath: \NorthwindLighter.CustomerCustomerDemo.customerTypeID,
      destinationColumn: NorthwindLighter.CustomerDemographic.schema.id
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ customerID, customerTypeID ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``CustomerCustomerDemo`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM CustomerCustomerDemo", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = CustomerCustomerDemo(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      customerID: ((indices.idx_customerID >= 0) && (indices.idx_customerID < argc) ? (sqlite3_column_text(statement, indices.idx_customerID).flatMap(String.init(cString:))) : nil) ?? Self.schema.customerID.defaultValue,
      customerTypeID: ((indices.idx_customerTypeID >= 0) && (indices.idx_customerTypeID < argc) ? (sqlite3_column_text(statement, indices.idx_customerTypeID).flatMap(String.init(cString:))) : nil) ?? Self.schema.customerTypeID.defaultValue
    )
  }
  
  /**
   * Bind all ``CustomerCustomerDemo`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE CustomerCustomerDemo SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = CustomerCustomerDemo(customerID: "Hello", customerTypeID: "World")
   * let ok = record.bind(to: statement, indices: ( 1, 2 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try customerID.withCString() { ( s ) in
      if indices.idx_customerID >= 0 {
        sqlite3_bind_text(statement, indices.idx_customerID, s, -1, nil)
      }
      return try customerTypeID.withCString() { ( s ) in
        if indices.idx_customerTypeID >= 0 {
          sqlite3_bind_text(statement, indices.idx_customerTypeID, s, -1, nil)
        }
        return try execute()
      }
    }
  }
}

public extension NorthwindLighter.CustomerDemographic {
  
  /**
   * Static type information for the ``CustomerDemographic`` record (`CustomerDemographics` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_customerDesc: Int32 )
    public typealias RecordType = NorthwindLighter.CustomerDemographic
    
    /// The SQL table name associated with the ``CustomerDemographic`` record.
    public static let externalName = "CustomerDemographics"
    
    /// The number of columns the `CustomerDemographics` table has.
    public static let columnCount : Int32 = 2
    
    /// Information on the records primary key (``CustomerDemographic/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.CustomerDemographic, String>(
      externalName: "CustomerTypeID",
      defaultValue: "",
      keyPath: \NorthwindLighter.CustomerDemographic.id
    )
    
    /// SQL to `SELECT` all columns of the `CustomerDemographics` table.
    public static let select = #"SELECT "CustomerTypeID", "CustomerDesc" FROM "CustomerDemographics""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CustomerTypeID", "CustomerDesc""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, CustomerDemographics_id FROM CustomerDemographics`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `CustomerDemographics_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CustomerTypeID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "CustomerDesc") == 0 {
          indices.idx_customerDesc = i
        }
      }
      return indices
    }
    
    /// Type information for property ``CustomerDemographic/id`` (`CustomerTypeID` column).
    public let id = MappedColumn<NorthwindLighter.CustomerDemographic, String>(
      externalName: "CustomerTypeID",
      defaultValue: "",
      keyPath: \NorthwindLighter.CustomerDemographic.id
    )
    
    /// Type information for property ``CustomerDemographic/customerDesc`` (`CustomerDesc` column).
    public let customerDesc = MappedColumn<NorthwindLighter.CustomerDemographic, String?>(
      externalName: "CustomerDesc",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CustomerDemographic.customerDesc
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, customerDesc ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``CustomerDemographic`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM CustomerDemographics", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = CustomerDemographic(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: ((indices.idx_id >= 0) && (indices.idx_id < argc) ? (sqlite3_column_text(statement, indices.idx_id).flatMap(String.init(cString:))) : nil) ?? Self.schema.id.defaultValue,
      customerDesc: (indices.idx_customerDesc >= 0) && (indices.idx_customerDesc < argc) ? (sqlite3_column_text(statement, indices.idx_customerDesc).flatMap(String.init(cString:))) : Self.schema.customerDesc.defaultValue
    )
  }
  
  /**
   * Bind all ``CustomerDemographic`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "CustomerDemographics" SET "CustomerDesc" = ? WHERE "CustomerTypeID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = CustomerDemographic(id: "Hello", customerDesc: "World")
   * let ok = record.bind(to: statement, indices: ( 2, 1 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try id.withCString() { ( s ) in
      if indices.idx_id >= 0 {
        sqlite3_bind_text(statement, indices.idx_id, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(customerDesc) { ( s ) in
        if indices.idx_customerDesc >= 0 {
          sqlite3_bind_text(statement, indices.idx_customerDesc, s, -1, nil)
        }
        return try execute()
      }
    }
  }
}

public extension NorthwindLighter.Customer {
  
  /**
   * Static type information for the ``Customer`` record (`Customers` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_companyName: Int32, idx_contactName: Int32, idx_contactTitle: Int32, idx_address: Int32, idx_city: Int32, idx_region: Int32, idx_postalCode: Int32, idx_country: Int32, idx_phone: Int32, idx_fax: Int32 )
    public typealias RecordType = NorthwindLighter.Customer
    
    /// The SQL table name associated with the ``Customer`` record.
    public static let externalName = "Customers"
    
    /// The number of columns the `Customers` table has.
    public static let columnCount : Int32 = 11
    
    /// Information on the records primary key (``Customer/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "CustomerID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.id
    )
    
    /// SQL to `SELECT` all columns of the `Customers` table.
    public static let select = #"SELECT "CustomerID", "CompanyName", "ContactName", "ContactTitle", "Address", "City", "Region", "PostalCode", "Country", "Phone", "Fax" FROM "Customers""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CustomerID", "CompanyName", "ContactName", "ContactTitle", "Address", "City", "Region", "PostalCode", "Country", "Phone", "Fax""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Customers_id FROM Customers`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Customers_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CustomerID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "CompanyName") == 0 {
          indices.idx_companyName = i
        }
        else if strcmp(col!, "ContactName") == 0 {
          indices.idx_contactName = i
        }
        else if strcmp(col!, "ContactTitle") == 0 {
          indices.idx_contactTitle = i
        }
        else if strcmp(col!, "Address") == 0 {
          indices.idx_address = i
        }
        else if strcmp(col!, "City") == 0 {
          indices.idx_city = i
        }
        else if strcmp(col!, "Region") == 0 {
          indices.idx_region = i
        }
        else if strcmp(col!, "PostalCode") == 0 {
          indices.idx_postalCode = i
        }
        else if strcmp(col!, "Country") == 0 {
          indices.idx_country = i
        }
        else if strcmp(col!, "Phone") == 0 {
          indices.idx_phone = i
        }
        else if strcmp(col!, "Fax") == 0 {
          indices.idx_fax = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Customer/id`` (`CustomerID` column).
    public let id = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "CustomerID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.id
    )
    
    /// Type information for property ``Customer/companyName`` (`CompanyName` column).
    public let companyName = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "CompanyName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.companyName
    )
    
    /// Type information for property ``Customer/contactName`` (`ContactName` column).
    public let contactName = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "ContactName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.contactName
    )
    
    /// Type information for property ``Customer/contactTitle`` (`ContactTitle` column).
    public let contactTitle = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "ContactTitle",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.contactTitle
    )
    
    /// Type information for property ``Customer/address`` (`Address` column).
    public let address = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "Address",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.address
    )
    
    /// Type information for property ``Customer/city`` (`City` column).
    public let city = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "City",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.city
    )
    
    /// Type information for property ``Customer/region`` (`Region` column).
    public let region = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "Region",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.region
    )
    
    /// Type information for property ``Customer/postalCode`` (`PostalCode` column).
    public let postalCode = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "PostalCode",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.postalCode
    )
    
    /// Type information for property ``Customer/country`` (`Country` column).
    public let country = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "Country",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.country
    )
    
    /// Type information for property ``Customer/phone`` (`Phone` column).
    public let phone = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "Phone",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.phone
    )
    
    /// Type information for property ``Customer/fax`` (`Fax` column).
    public let fax = MappedColumn<NorthwindLighter.Customer, String?>(
      externalName: "Fax",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Customer.fax
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, companyName, contactName, contactTitle, address, city, region, postalCode, country, phone, fax ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Customer`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Customers", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Customer(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: (indices.idx_id >= 0) && (indices.idx_id < argc) ? (sqlite3_column_text(statement, indices.idx_id).flatMap(String.init(cString:))) : Self.schema.id.defaultValue,
      companyName: (indices.idx_companyName >= 0) && (indices.idx_companyName < argc) ? (sqlite3_column_text(statement, indices.idx_companyName).flatMap(String.init(cString:))) : Self.schema.companyName.defaultValue,
      contactName: (indices.idx_contactName >= 0) && (indices.idx_contactName < argc) ? (sqlite3_column_text(statement, indices.idx_contactName).flatMap(String.init(cString:))) : Self.schema.contactName.defaultValue,
      contactTitle: (indices.idx_contactTitle >= 0) && (indices.idx_contactTitle < argc) ? (sqlite3_column_text(statement, indices.idx_contactTitle).flatMap(String.init(cString:))) : Self.schema.contactTitle.defaultValue,
      address: (indices.idx_address >= 0) && (indices.idx_address < argc) ? (sqlite3_column_text(statement, indices.idx_address).flatMap(String.init(cString:))) : Self.schema.address.defaultValue,
      city: (indices.idx_city >= 0) && (indices.idx_city < argc) ? (sqlite3_column_text(statement, indices.idx_city).flatMap(String.init(cString:))) : Self.schema.city.defaultValue,
      region: (indices.idx_region >= 0) && (indices.idx_region < argc) ? (sqlite3_column_text(statement, indices.idx_region).flatMap(String.init(cString:))) : Self.schema.region.defaultValue,
      postalCode: (indices.idx_postalCode >= 0) && (indices.idx_postalCode < argc) ? (sqlite3_column_text(statement, indices.idx_postalCode).flatMap(String.init(cString:))) : Self.schema.postalCode.defaultValue,
      country: (indices.idx_country >= 0) && (indices.idx_country < argc) ? (sqlite3_column_text(statement, indices.idx_country).flatMap(String.init(cString:))) : Self.schema.country.defaultValue,
      phone: (indices.idx_phone >= 0) && (indices.idx_phone < argc) ? (sqlite3_column_text(statement, indices.idx_phone).flatMap(String.init(cString:))) : Self.schema.phone.defaultValue,
      fax: (indices.idx_fax >= 0) && (indices.idx_fax < argc) ? (sqlite3_column_text(statement, indices.idx_fax).flatMap(String.init(cString:))) : Self.schema.fax.defaultValue
    )
  }
  
  /**
   * Bind all ``Customer`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Customers" SET "CompanyName" = ?, "ContactName" = ?, "ContactTitle" = ?, "Address" = ?, "City" = ?, "Region" = ?, "PostalCode" = ?, "Country" = ?, "Phone" = ?, "Fax" = ? WHERE "CustomerID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Customer(id: "Hello", companyName: "World", contactName: "Duck", contactTitle: "Donald")
   * let ok = record.bind(to: statement, indices: ( 11, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(id) { ( s ) in
      if indices.idx_id >= 0 {
        sqlite3_bind_text(statement, indices.idx_id, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(companyName) { ( s ) in
        if indices.idx_companyName >= 0 {
          sqlite3_bind_text(statement, indices.idx_companyName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(contactName) { ( s ) in
          if indices.idx_contactName >= 0 {
            sqlite3_bind_text(statement, indices.idx_contactName, s, -1, nil)
          }
          return try NorthwindLighter.withOptCString(contactTitle) { ( s ) in
            if indices.idx_contactTitle >= 0 {
              sqlite3_bind_text(statement, indices.idx_contactTitle, s, -1, nil)
            }
            return try NorthwindLighter.withOptCString(address) { ( s ) in
              if indices.idx_address >= 0 {
                sqlite3_bind_text(statement, indices.idx_address, s, -1, nil)
              }
              return try NorthwindLighter.withOptCString(city) { ( s ) in
                if indices.idx_city >= 0 {
                  sqlite3_bind_text(statement, indices.idx_city, s, -1, nil)
                }
                return try NorthwindLighter.withOptCString(region) { ( s ) in
                  if indices.idx_region >= 0 {
                    sqlite3_bind_text(statement, indices.idx_region, s, -1, nil)
                  }
                  return try NorthwindLighter.withOptCString(postalCode) { ( s ) in
                    if indices.idx_postalCode >= 0 {
                      sqlite3_bind_text(statement, indices.idx_postalCode, s, -1, nil)
                    }
                    return try NorthwindLighter.withOptCString(country) { ( s ) in
                      if indices.idx_country >= 0 {
                        sqlite3_bind_text(statement, indices.idx_country, s, -1, nil)
                      }
                      return try NorthwindLighter.withOptCString(phone) { ( s ) in
                        if indices.idx_phone >= 0 {
                          sqlite3_bind_text(statement, indices.idx_phone, s, -1, nil)
                        }
                        return try NorthwindLighter.withOptCString(fax) { ( s ) in
                          if indices.idx_fax >= 0 {
                            sqlite3_bind_text(statement, indices.idx_fax, s, -1, nil)
                          }
                          return try execute()
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.Employee {
  
  /**
   * Static type information for the ``Employee`` record (`Employees` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_lastName: Int32, idx_firstName: Int32, idx_title: Int32, idx_titleOfCourtesy: Int32, idx_birthDate: Int32, idx_hireDate: Int32, idx_address: Int32, idx_city: Int32, idx_region: Int32, idx_postalCode: Int32, idx_country: Int32, idx_homePhone: Int32, idx_extension: Int32, idx_photo: Int32, idx_notes: Int32, idx_reportsTo: Int32, idx_photoPath: Int32 )
    public typealias RecordType = NorthwindLighter.Employee
    
    /// The SQL table name associated with the ``Employee`` record.
    public static let externalName = "Employees"
    
    /// The number of columns the `Employees` table has.
    public static let columnCount : Int32 = 18
    
    /// Information on the records primary key (``Employee/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.Employee, Int?>(
      externalName: "EmployeeID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.id
    )
    
    /// SQL to `SELECT` all columns of the `Employees` table.
    public static let select = #"SELECT "EmployeeID", "LastName", "FirstName", "Title", "TitleOfCourtesy", "BirthDate", "HireDate", "Address", "City", "Region", "PostalCode", "Country", "HomePhone", "Extension", "Photo", "Notes", "ReportsTo", "PhotoPath" FROM "Employees""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""EmployeeID", "LastName", "FirstName", "Title", "TitleOfCourtesy", "BirthDate", "HireDate", "Address", "City", "Region", "PostalCode", "Country", "HomePhone", "Extension", "Photo", "Notes", "ReportsTo", "PhotoPath""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Employees_id FROM Employees`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Employees_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "EmployeeID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "LastName") == 0 {
          indices.idx_lastName = i
        }
        else if strcmp(col!, "FirstName") == 0 {
          indices.idx_firstName = i
        }
        else if strcmp(col!, "Title") == 0 {
          indices.idx_title = i
        }
        else if strcmp(col!, "TitleOfCourtesy") == 0 {
          indices.idx_titleOfCourtesy = i
        }
        else if strcmp(col!, "BirthDate") == 0 {
          indices.idx_birthDate = i
        }
        else if strcmp(col!, "HireDate") == 0 {
          indices.idx_hireDate = i
        }
        else if strcmp(col!, "Address") == 0 {
          indices.idx_address = i
        }
        else if strcmp(col!, "City") == 0 {
          indices.idx_city = i
        }
        else if strcmp(col!, "Region") == 0 {
          indices.idx_region = i
        }
        else if strcmp(col!, "PostalCode") == 0 {
          indices.idx_postalCode = i
        }
        else if strcmp(col!, "Country") == 0 {
          indices.idx_country = i
        }
        else if strcmp(col!, "HomePhone") == 0 {
          indices.idx_homePhone = i
        }
        else if strcmp(col!, "Extension") == 0 {
          indices.idx_extension = i
        }
        else if strcmp(col!, "Photo") == 0 {
          indices.idx_photo = i
        }
        else if strcmp(col!, "Notes") == 0 {
          indices.idx_notes = i
        }
        else if strcmp(col!, "ReportsTo") == 0 {
          indices.idx_reportsTo = i
        }
        else if strcmp(col!, "PhotoPath") == 0 {
          indices.idx_photoPath = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Employee/id`` (`EmployeeID` column).
    public let id = MappedColumn<NorthwindLighter.Employee, Int?>(
      externalName: "EmployeeID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.id
    )
    
    /// Type information for property ``Employee/lastName`` (`LastName` column).
    public let lastName = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "LastName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.lastName
    )
    
    /// Type information for property ``Employee/firstName`` (`FirstName` column).
    public let firstName = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "FirstName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.firstName
    )
    
    /// Type information for property ``Employee/title`` (`Title` column).
    public let title = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "Title",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.title
    )
    
    /// Type information for property ``Employee/titleOfCourtesy`` (`TitleOfCourtesy` column).
    public let titleOfCourtesy = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "TitleOfCourtesy",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.titleOfCourtesy
    )
    
    /// Type information for property ``Employee/birthDate`` (`BirthDate` column).
    public let birthDate = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "BirthDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.birthDate
    )
    
    /// Type information for property ``Employee/hireDate`` (`HireDate` column).
    public let hireDate = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "HireDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.hireDate
    )
    
    /// Type information for property ``Employee/address`` (`Address` column).
    public let address = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "Address",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.address
    )
    
    /// Type information for property ``Employee/city`` (`City` column).
    public let city = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "City",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.city
    )
    
    /// Type information for property ``Employee/region`` (`Region` column).
    public let region = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "Region",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.region
    )
    
    /// Type information for property ``Employee/postalCode`` (`PostalCode` column).
    public let postalCode = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "PostalCode",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.postalCode
    )
    
    /// Type information for property ``Employee/country`` (`Country` column).
    public let country = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "Country",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.country
    )
    
    /// Type information for property ``Employee/homePhone`` (`HomePhone` column).
    public let homePhone = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "HomePhone",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.homePhone
    )
    
    /// Type information for property ``Employee/extension`` (`Extension` column).
    public let `extension` = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "Extension",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.`extension`
    )
    
    /// Type information for property ``Employee/photo`` (`Photo` column).
    public let photo = MappedColumn<NorthwindLighter.Employee, [ UInt8 ]?>(
      externalName: "Photo",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.photo
    )
    
    /// Type information for property ``Employee/notes`` (`Notes` column).
    public let notes = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "Notes",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.notes
    )
    
    /// Type information for property ``Employee/reportsTo`` (`ReportsTo` column).
    public let reportsTo = MappedForeignKey<NorthwindLighter.Employee, Int?, MappedColumn<NorthwindLighter.Employee, Int?>>(
      externalName: "ReportsTo",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.reportsTo,
      destinationColumn: NorthwindLighter.Employee.schema.id
    )
    
    /// Type information for property ``Employee/photoPath`` (`PhotoPath` column).
    public let photoPath = MappedColumn<NorthwindLighter.Employee, String?>(
      externalName: "PhotoPath",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Employee.photoPath
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, lastName, firstName, title, titleOfCourtesy, birthDate, hireDate, address, city, region, postalCode, country, homePhone, `extension`, photo, notes, reportsTo, photoPath ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Employee`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Employees", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Employee(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: (indices.idx_id >= 0) && (indices.idx_id < argc) ? (sqlite3_column_type(statement, indices.idx_id) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_id)) : nil) : Self.schema.id.defaultValue,
      lastName: (indices.idx_lastName >= 0) && (indices.idx_lastName < argc) ? (sqlite3_column_text(statement, indices.idx_lastName).flatMap(String.init(cString:))) : Self.schema.lastName.defaultValue,
      firstName: (indices.idx_firstName >= 0) && (indices.idx_firstName < argc) ? (sqlite3_column_text(statement, indices.idx_firstName).flatMap(String.init(cString:))) : Self.schema.firstName.defaultValue,
      title: (indices.idx_title >= 0) && (indices.idx_title < argc) ? (sqlite3_column_text(statement, indices.idx_title).flatMap(String.init(cString:))) : Self.schema.title.defaultValue,
      titleOfCourtesy: (indices.idx_titleOfCourtesy >= 0) && (indices.idx_titleOfCourtesy < argc) ? (sqlite3_column_text(statement, indices.idx_titleOfCourtesy).flatMap(String.init(cString:))) : Self.schema.titleOfCourtesy.defaultValue,
      birthDate: (indices.idx_birthDate >= 0) && (indices.idx_birthDate < argc) ? (sqlite3_column_text(statement, indices.idx_birthDate).flatMap(String.init(cString:))) : Self.schema.birthDate.defaultValue,
      hireDate: (indices.idx_hireDate >= 0) && (indices.idx_hireDate < argc) ? (sqlite3_column_text(statement, indices.idx_hireDate).flatMap(String.init(cString:))) : Self.schema.hireDate.defaultValue,
      address: (indices.idx_address >= 0) && (indices.idx_address < argc) ? (sqlite3_column_text(statement, indices.idx_address).flatMap(String.init(cString:))) : Self.schema.address.defaultValue,
      city: (indices.idx_city >= 0) && (indices.idx_city < argc) ? (sqlite3_column_text(statement, indices.idx_city).flatMap(String.init(cString:))) : Self.schema.city.defaultValue,
      region: (indices.idx_region >= 0) && (indices.idx_region < argc) ? (sqlite3_column_text(statement, indices.idx_region).flatMap(String.init(cString:))) : Self.schema.region.defaultValue,
      postalCode: (indices.idx_postalCode >= 0) && (indices.idx_postalCode < argc) ? (sqlite3_column_text(statement, indices.idx_postalCode).flatMap(String.init(cString:))) : Self.schema.postalCode.defaultValue,
      country: (indices.idx_country >= 0) && (indices.idx_country < argc) ? (sqlite3_column_text(statement, indices.idx_country).flatMap(String.init(cString:))) : Self.schema.country.defaultValue,
      homePhone: (indices.idx_homePhone >= 0) && (indices.idx_homePhone < argc) ? (sqlite3_column_text(statement, indices.idx_homePhone).flatMap(String.init(cString:))) : Self.schema.homePhone.defaultValue,
      extension: (indices.idx_extension >= 0) && (indices.idx_extension < argc) ? (sqlite3_column_text(statement, indices.idx_extension).flatMap(String.init(cString:))) : Self.schema.`extension`.defaultValue,
      photo: (indices.idx_photo >= 0) && (indices.idx_photo < argc) ? (sqlite3_column_blob(statement, indices.idx_photo).flatMap({ [ UInt8 ](UnsafeRawBufferPointer(start: $0, count: Int(sqlite3_column_bytes(statement, indices.idx_photo)))) })) : Self.schema.photo.defaultValue,
      notes: (indices.idx_notes >= 0) && (indices.idx_notes < argc) ? (sqlite3_column_text(statement, indices.idx_notes).flatMap(String.init(cString:))) : Self.schema.notes.defaultValue,
      reportsTo: (indices.idx_reportsTo >= 0) && (indices.idx_reportsTo < argc) ? (sqlite3_column_type(statement, indices.idx_reportsTo) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_reportsTo)) : nil) : Self.schema.reportsTo.defaultValue,
      photoPath: (indices.idx_photoPath >= 0) && (indices.idx_photoPath < argc) ? (sqlite3_column_text(statement, indices.idx_photoPath).flatMap(String.init(cString:))) : Self.schema.photoPath.defaultValue
    )
  }
  
  /**
   * Bind all ``Employee`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Employees" SET "LastName" = ?, "FirstName" = ?, "Title" = ?, "TitleOfCourtesy" = ?, "BirthDate" = ?, "HireDate" = ?, "Address" = ?, "City" = ?, "Region" = ?, "PostalCode" = ?, "Country" = ?, "HomePhone" = ?, "Extension" = ?, "Photo" = ?, "Notes" = ?, "ReportsTo" = ?, "PhotoPath" = ? WHERE "EmployeeID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Employee(id: 1, lastName: "Hello", firstName: "World", title: "Duck")
   * let ok = record.bind(to: statement, indices: ( 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_id >= 0 {
      if let id = id {
        sqlite3_bind_int64(statement, indices.idx_id, Int64(id))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_id)
      }
    }
    return try NorthwindLighter.withOptCString(lastName) { ( s ) in
      if indices.idx_lastName >= 0 {
        sqlite3_bind_text(statement, indices.idx_lastName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(firstName) { ( s ) in
        if indices.idx_firstName >= 0 {
          sqlite3_bind_text(statement, indices.idx_firstName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(title) { ( s ) in
          if indices.idx_title >= 0 {
            sqlite3_bind_text(statement, indices.idx_title, s, -1, nil)
          }
          return try NorthwindLighter.withOptCString(titleOfCourtesy) { ( s ) in
            if indices.idx_titleOfCourtesy >= 0 {
              sqlite3_bind_text(statement, indices.idx_titleOfCourtesy, s, -1, nil)
            }
            return try NorthwindLighter.withOptCString(birthDate) { ( s ) in
              if indices.idx_birthDate >= 0 {
                sqlite3_bind_text(statement, indices.idx_birthDate, s, -1, nil)
              }
              return try NorthwindLighter.withOptCString(hireDate) { ( s ) in
                if indices.idx_hireDate >= 0 {
                  sqlite3_bind_text(statement, indices.idx_hireDate, s, -1, nil)
                }
                return try NorthwindLighter.withOptCString(address) { ( s ) in
                  if indices.idx_address >= 0 {
                    sqlite3_bind_text(statement, indices.idx_address, s, -1, nil)
                  }
                  return try NorthwindLighter.withOptCString(city) { ( s ) in
                    if indices.idx_city >= 0 {
                      sqlite3_bind_text(statement, indices.idx_city, s, -1, nil)
                    }
                    return try NorthwindLighter.withOptCString(region) { ( s ) in
                      if indices.idx_region >= 0 {
                        sqlite3_bind_text(statement, indices.idx_region, s, -1, nil)
                      }
                      return try NorthwindLighter.withOptCString(postalCode) { ( s ) in
                        if indices.idx_postalCode >= 0 {
                          sqlite3_bind_text(statement, indices.idx_postalCode, s, -1, nil)
                        }
                        return try NorthwindLighter.withOptCString(country) { ( s ) in
                          if indices.idx_country >= 0 {
                            sqlite3_bind_text(statement, indices.idx_country, s, -1, nil)
                          }
                          return try NorthwindLighter.withOptCString(homePhone) { ( s ) in
                            if indices.idx_homePhone >= 0 {
                              sqlite3_bind_text(statement, indices.idx_homePhone, s, -1, nil)
                            }
                            return try NorthwindLighter.withOptCString(`extension`) { ( s ) in
                              if indices.idx_extension >= 0 {
                                sqlite3_bind_text(statement, indices.idx_extension, s, -1, nil)
                              }
                              return try NorthwindLighter.withOptBlob(photo) { ( rbp ) in
                                if indices.idx_photo >= 0 {
                                  sqlite3_bind_blob(statement, indices.idx_photo, rbp.baseAddress, Int32(rbp.count), nil)
                                }
                                return try NorthwindLighter.withOptCString(notes) { ( s ) in
                                  if indices.idx_notes >= 0 {
                                    sqlite3_bind_text(statement, indices.idx_notes, s, -1, nil)
                                  }
                                  if indices.idx_reportsTo >= 0 {
                                    if let reportsTo = reportsTo {
                                      sqlite3_bind_int64(statement, indices.idx_reportsTo, Int64(reportsTo))
                                    }
                                    else {
                                      sqlite3_bind_null(statement, indices.idx_reportsTo)
                                    }
                                  }
                                  return try NorthwindLighter.withOptCString(photoPath) { ( s ) in
                                    if indices.idx_photoPath >= 0 {
                                      sqlite3_bind_text(statement, indices.idx_photoPath, s, -1, nil)
                                    }
                                    return try execute()
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.EmployeeTerritory {
  
  /**
   * Static type information for the ``EmployeeTerritory`` record (`EmployeeTerritories` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLTableSchema {
    
    public typealias PropertyIndices = ( idx_employeeID: Int32, idx_territoryID: Int32 )
    public typealias RecordType = NorthwindLighter.EmployeeTerritory
    
    /// The SQL table name associated with the ``EmployeeTerritory`` record.
    public static let externalName = "EmployeeTerritories"
    
    /// The number of columns the `EmployeeTerritories` table has.
    public static let columnCount : Int32 = 2
    
    /// SQL to `SELECT` all columns of the `EmployeeTerritories` table.
    public static let select = #"SELECT "EmployeeID", "TerritoryID" FROM "EmployeeTerritories""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""EmployeeID", "TerritoryID""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, EmployeeTerritories_id FROM EmployeeTerritories`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `EmployeeTerritories_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "EmployeeID") == 0 {
          indices.idx_employeeID = i
        }
        else if strcmp(col!, "TerritoryID") == 0 {
          indices.idx_territoryID = i
        }
      }
      return indices
    }
    
    /// Type information for property ``EmployeeTerritory/employeeID`` (`EmployeeID` column).
    public let employeeID = MappedForeignKey<NorthwindLighter.EmployeeTerritory, Int, MappedColumn<NorthwindLighter.Employee, Int?>>(
      externalName: "EmployeeID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.EmployeeTerritory.employeeID,
      destinationColumn: NorthwindLighter.Employee.schema.id
    )
    
    /// Type information for property ``EmployeeTerritory/territoryID`` (`TerritoryID` column).
    public let territoryID = MappedForeignKey<NorthwindLighter.EmployeeTerritory, String, MappedColumn<NorthwindLighter.Territory, String>>(
      externalName: "TerritoryID",
      defaultValue: "",
      keyPath: \NorthwindLighter.EmployeeTerritory.territoryID,
      destinationColumn: NorthwindLighter.Territory.schema.id
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ employeeID, territoryID ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``EmployeeTerritory`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM EmployeeTerritories", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = EmployeeTerritory(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      employeeID: (indices.idx_employeeID >= 0) && (indices.idx_employeeID < argc) && (sqlite3_column_type(statement, indices.idx_employeeID) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_employeeID)) : Self.schema.employeeID.defaultValue,
      territoryID: ((indices.idx_territoryID >= 0) && (indices.idx_territoryID < argc) ? (sqlite3_column_text(statement, indices.idx_territoryID).flatMap(String.init(cString:))) : nil) ?? Self.schema.territoryID.defaultValue
    )
  }
  
  /**
   * Bind all ``EmployeeTerritory`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE EmployeeTerritories SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = EmployeeTerritory(employeeID: 1, territoryID: "Hello")
   * let ok = record.bind(to: statement, indices: ( 1, 2 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_employeeID >= 0 {
      sqlite3_bind_int64(statement, indices.idx_employeeID, Int64(employeeID))
    }
    return try territoryID.withCString() { ( s ) in
      if indices.idx_territoryID >= 0 {
        sqlite3_bind_text(statement, indices.idx_territoryID, s, -1, nil)
      }
      return try execute()
    }
  }
}

public extension NorthwindLighter.OrderDetail {
  
  /**
   * Static type information for the ``OrderDetail`` record (`Order Details` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLTableSchema {
    
    public typealias PropertyIndices = ( idx_orderID: Int32, idx_productID: Int32, idx_unitPrice: Int32, idx_quantity: Int32, idx_discount: Int32 )
    public typealias RecordType = NorthwindLighter.OrderDetail
    
    /// The SQL table name associated with the ``OrderDetail`` record.
    public static let externalName = "Order Details"
    
    /// The number of columns the `Order Details` table has.
    public static let columnCount : Int32 = 5
    
    /// SQL to `SELECT` all columns of the `Order Details` table.
    public static let select = #"SELECT "OrderID", "ProductID", "UnitPrice", "Quantity", "Discount" FROM "Order Details""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""OrderID", "ProductID", "UnitPrice", "Quantity", "Discount""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Order Details_id FROM Order Details`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Order Details_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "OrderID") == 0 {
          indices.idx_orderID = i
        }
        else if strcmp(col!, "ProductID") == 0 {
          indices.idx_productID = i
        }
        else if strcmp(col!, "UnitPrice") == 0 {
          indices.idx_unitPrice = i
        }
        else if strcmp(col!, "Quantity") == 0 {
          indices.idx_quantity = i
        }
        else if strcmp(col!, "Discount") == 0 {
          indices.idx_discount = i
        }
      }
      return indices
    }
    
    /// Type information for property ``OrderDetail/orderID`` (`OrderID` column).
    public let orderID = MappedForeignKey<NorthwindLighter.OrderDetail, Int, MappedColumn<NorthwindLighter.Order, Int>>(
      externalName: "OrderID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.OrderDetail.orderID,
      destinationColumn: NorthwindLighter.Order.schema.id
    )
    
    /// Type information for property ``OrderDetail/productID`` (`ProductID` column).
    public let productID = MappedColumn<NorthwindLighter.OrderDetail, Int>(
      externalName: "ProductID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.OrderDetail.productID
    )
    
    /// Type information for property ``OrderDetail/unitPrice`` (`UnitPrice` column).
    public let unitPrice = MappedColumn<NorthwindLighter.OrderDetail, String>(
      externalName: "UnitPrice",
      defaultValue: "0",
      keyPath: \NorthwindLighter.OrderDetail.unitPrice
    )
    
    /// Type information for property ``OrderDetail/quantity`` (`Quantity` column).
    public let quantity = MappedColumn<NorthwindLighter.OrderDetail, Int>(
      externalName: "Quantity",
      defaultValue: 1,
      keyPath: \NorthwindLighter.OrderDetail.quantity
    )
    
    /// Type information for property ``OrderDetail/discount`` (`Discount` column).
    public let discount = MappedColumn<NorthwindLighter.OrderDetail, Double>(
      externalName: "Discount",
      defaultValue: 0.0,
      keyPath: \NorthwindLighter.OrderDetail.discount
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ orderID, productID, unitPrice, quantity, discount ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``OrderDetail`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Order Details", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = OrderDetail(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      orderID: (indices.idx_orderID >= 0) && (indices.idx_orderID < argc) && (sqlite3_column_type(statement, indices.idx_orderID) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_orderID)) : Self.schema.orderID.defaultValue,
      productID: (indices.idx_productID >= 0) && (indices.idx_productID < argc) && (sqlite3_column_type(statement, indices.idx_productID) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_productID)) : Self.schema.productID.defaultValue,
      unitPrice: ((indices.idx_unitPrice >= 0) && (indices.idx_unitPrice < argc) ? (sqlite3_column_text(statement, indices.idx_unitPrice).flatMap(String.init(cString:))) : nil) ?? Self.schema.unitPrice.defaultValue,
      quantity: (indices.idx_quantity >= 0) && (indices.idx_quantity < argc) && (sqlite3_column_type(statement, indices.idx_quantity) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_quantity)) : Self.schema.quantity.defaultValue,
      discount: (indices.idx_discount >= 0) && (indices.idx_discount < argc) && (sqlite3_column_type(statement, indices.idx_discount) != SQLITE_NULL) ? sqlite3_column_double(statement, indices.idx_discount) : Self.schema.discount.defaultValue
    )
  }
  
  /**
   * Bind all ``OrderDetail`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Order Details" SET "UnitPrice" = ?, "Quantity" = ?, "Discount" = ? WHERE "OrderID" = ? AND "ProductID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = OrderDetail(orderID: 1, productID: 2, unitPrice: "Hello", quantity: 3, discount: 4)
   * let ok = record.bind(to: statement, indices: ( 4, 5, 1, 2, 3 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_orderID >= 0 {
      sqlite3_bind_int64(statement, indices.idx_orderID, Int64(orderID))
    }
    if indices.idx_productID >= 0 {
      sqlite3_bind_int64(statement, indices.idx_productID, Int64(productID))
    }
    return try unitPrice.withCString() { ( s ) in
      if indices.idx_unitPrice >= 0 {
        sqlite3_bind_text(statement, indices.idx_unitPrice, s, -1, nil)
      }
      if indices.idx_quantity >= 0 {
        sqlite3_bind_int64(statement, indices.idx_quantity, Int64(quantity))
      }
      if indices.idx_discount >= 0 {
        sqlite3_bind_double(statement, indices.idx_discount, discount)
      }
      return try execute()
    }
  }
}

public extension NorthwindLighter.Order {
  
  /**
   * Static type information for the ``Order`` record (`Orders` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_customerID: Int32, idx_employeeID: Int32, idx_orderDate: Int32, idx_requiredDate: Int32, idx_shippedDate: Int32, idx_shipVia: Int32, idx_freight: Int32, idx_shipName: Int32, idx_shipAddress: Int32, idx_shipCity: Int32, idx_shipRegion: Int32, idx_shipPostalCode: Int32, idx_shipCountry: Int32 )
    public typealias RecordType = NorthwindLighter.Order
    
    /// The SQL table name associated with the ``Order`` record.
    public static let externalName = "Orders"
    
    /// The number of columns the `Orders` table has.
    public static let columnCount : Int32 = 14
    
    /// Information on the records primary key (``Order/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.Order, Int>(
      externalName: "OrderID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Order.id
    )
    
    /// SQL to `SELECT` all columns of the `Orders` table.
    public static let select = #"SELECT "OrderID", "CustomerID", "EmployeeID", "OrderDate", "RequiredDate", "ShippedDate", "ShipVia", "Freight", "ShipName", "ShipAddress", "ShipCity", "ShipRegion", "ShipPostalCode", "ShipCountry" FROM "Orders""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""OrderID", "CustomerID", "EmployeeID", "OrderDate", "RequiredDate", "ShippedDate", "ShipVia", "Freight", "ShipName", "ShipAddress", "ShipCity", "ShipRegion", "ShipPostalCode", "ShipCountry""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Orders_id FROM Orders`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Orders_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "OrderID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "CustomerID") == 0 {
          indices.idx_customerID = i
        }
        else if strcmp(col!, "EmployeeID") == 0 {
          indices.idx_employeeID = i
        }
        else if strcmp(col!, "OrderDate") == 0 {
          indices.idx_orderDate = i
        }
        else if strcmp(col!, "RequiredDate") == 0 {
          indices.idx_requiredDate = i
        }
        else if strcmp(col!, "ShippedDate") == 0 {
          indices.idx_shippedDate = i
        }
        else if strcmp(col!, "ShipVia") == 0 {
          indices.idx_shipVia = i
        }
        else if strcmp(col!, "Freight") == 0 {
          indices.idx_freight = i
        }
        else if strcmp(col!, "ShipName") == 0 {
          indices.idx_shipName = i
        }
        else if strcmp(col!, "ShipAddress") == 0 {
          indices.idx_shipAddress = i
        }
        else if strcmp(col!, "ShipCity") == 0 {
          indices.idx_shipCity = i
        }
        else if strcmp(col!, "ShipRegion") == 0 {
          indices.idx_shipRegion = i
        }
        else if strcmp(col!, "ShipPostalCode") == 0 {
          indices.idx_shipPostalCode = i
        }
        else if strcmp(col!, "ShipCountry") == 0 {
          indices.idx_shipCountry = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Order/id`` (`OrderID` column).
    public let id = MappedColumn<NorthwindLighter.Order, Int>(
      externalName: "OrderID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Order.id
    )
    
    /// Type information for property ``Order/customerID`` (`CustomerID` column).
    public let customerID = MappedForeignKey<NorthwindLighter.Order, String?, MappedColumn<NorthwindLighter.Customer, String?>>(
      externalName: "CustomerID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.customerID,
      destinationColumn: NorthwindLighter.Customer.schema.id
    )
    
    /// Type information for property ``Order/employeeID`` (`EmployeeID` column).
    public let employeeID = MappedForeignKey<NorthwindLighter.Order, Int?, MappedColumn<NorthwindLighter.Employee, Int?>>(
      externalName: "EmployeeID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.employeeID,
      destinationColumn: NorthwindLighter.Employee.schema.id
    )
    
    /// Type information for property ``Order/orderDate`` (`OrderDate` column).
    public let orderDate = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "OrderDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.orderDate
    )
    
    /// Type information for property ``Order/requiredDate`` (`RequiredDate` column).
    public let requiredDate = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "RequiredDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.requiredDate
    )
    
    /// Type information for property ``Order/shippedDate`` (`ShippedDate` column).
    public let shippedDate = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "ShippedDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.shippedDate
    )
    
    /// Type information for property ``Order/shipVia`` (`ShipVia` column).
    public let shipVia = MappedForeignKey<NorthwindLighter.Order, Int?, MappedColumn<NorthwindLighter.Shipper, Int>>(
      externalName: "ShipVia",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.shipVia,
      destinationColumn: NorthwindLighter.Shipper.schema.id
    )
    
    /// Type information for property ``Order/freight`` (`Freight` column).
    public let freight = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "Freight",
      defaultValue: "0",
      keyPath: \NorthwindLighter.Order.freight
    )
    
    /// Type information for property ``Order/shipName`` (`ShipName` column).
    public let shipName = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "ShipName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.shipName
    )
    
    /// Type information for property ``Order/shipAddress`` (`ShipAddress` column).
    public let shipAddress = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "ShipAddress",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.shipAddress
    )
    
    /// Type information for property ``Order/shipCity`` (`ShipCity` column).
    public let shipCity = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "ShipCity",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.shipCity
    )
    
    /// Type information for property ``Order/shipRegion`` (`ShipRegion` column).
    public let shipRegion = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "ShipRegion",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.shipRegion
    )
    
    /// Type information for property ``Order/shipPostalCode`` (`ShipPostalCode` column).
    public let shipPostalCode = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "ShipPostalCode",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.shipPostalCode
    )
    
    /// Type information for property ``Order/shipCountry`` (`ShipCountry` column).
    public let shipCountry = MappedColumn<NorthwindLighter.Order, String?>(
      externalName: "ShipCountry",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Order.shipCountry
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, customerID, employeeID, orderDate, requiredDate, shippedDate, shipVia, freight, shipName, shipAddress, shipCity, shipRegion, shipPostalCode, shipCountry ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Order`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Orders", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Order(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: (indices.idx_id >= 0) && (indices.idx_id < argc) && (sqlite3_column_type(statement, indices.idx_id) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_id)) : Self.schema.id.defaultValue,
      customerID: (indices.idx_customerID >= 0) && (indices.idx_customerID < argc) ? (sqlite3_column_text(statement, indices.idx_customerID).flatMap(String.init(cString:))) : Self.schema.customerID.defaultValue,
      employeeID: (indices.idx_employeeID >= 0) && (indices.idx_employeeID < argc) ? (sqlite3_column_type(statement, indices.idx_employeeID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_employeeID)) : nil) : Self.schema.employeeID.defaultValue,
      orderDate: (indices.idx_orderDate >= 0) && (indices.idx_orderDate < argc) ? (sqlite3_column_text(statement, indices.idx_orderDate).flatMap(String.init(cString:))) : Self.schema.orderDate.defaultValue,
      requiredDate: (indices.idx_requiredDate >= 0) && (indices.idx_requiredDate < argc) ? (sqlite3_column_text(statement, indices.idx_requiredDate).flatMap(String.init(cString:))) : Self.schema.requiredDate.defaultValue,
      shippedDate: (indices.idx_shippedDate >= 0) && (indices.idx_shippedDate < argc) ? (sqlite3_column_text(statement, indices.idx_shippedDate).flatMap(String.init(cString:))) : Self.schema.shippedDate.defaultValue,
      shipVia: (indices.idx_shipVia >= 0) && (indices.idx_shipVia < argc) ? (sqlite3_column_type(statement, indices.idx_shipVia) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_shipVia)) : nil) : Self.schema.shipVia.defaultValue,
      freight: (indices.idx_freight >= 0) && (indices.idx_freight < argc) ? (sqlite3_column_text(statement, indices.idx_freight).flatMap(String.init(cString:))) : Self.schema.freight.defaultValue,
      shipName: (indices.idx_shipName >= 0) && (indices.idx_shipName < argc) ? (sqlite3_column_text(statement, indices.idx_shipName).flatMap(String.init(cString:))) : Self.schema.shipName.defaultValue,
      shipAddress: (indices.idx_shipAddress >= 0) && (indices.idx_shipAddress < argc) ? (sqlite3_column_text(statement, indices.idx_shipAddress).flatMap(String.init(cString:))) : Self.schema.shipAddress.defaultValue,
      shipCity: (indices.idx_shipCity >= 0) && (indices.idx_shipCity < argc) ? (sqlite3_column_text(statement, indices.idx_shipCity).flatMap(String.init(cString:))) : Self.schema.shipCity.defaultValue,
      shipRegion: (indices.idx_shipRegion >= 0) && (indices.idx_shipRegion < argc) ? (sqlite3_column_text(statement, indices.idx_shipRegion).flatMap(String.init(cString:))) : Self.schema.shipRegion.defaultValue,
      shipPostalCode: (indices.idx_shipPostalCode >= 0) && (indices.idx_shipPostalCode < argc) ? (sqlite3_column_text(statement, indices.idx_shipPostalCode).flatMap(String.init(cString:))) : Self.schema.shipPostalCode.defaultValue,
      shipCountry: (indices.idx_shipCountry >= 0) && (indices.idx_shipCountry < argc) ? (sqlite3_column_text(statement, indices.idx_shipCountry).flatMap(String.init(cString:))) : Self.schema.shipCountry.defaultValue
    )
  }
  
  /**
   * Bind all ``Order`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Orders" SET "CustomerID" = ?, "EmployeeID" = ?, "OrderDate" = ?, "RequiredDate" = ?, "ShippedDate" = ?, "ShipVia" = ?, "Freight" = ?, "ShipName" = ?, "ShipAddress" = ?, "ShipCity" = ?, "ShipRegion" = ?, "ShipPostalCode" = ?, "ShipCountry" = ? WHERE "OrderID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Order(id: 1, customerID: "Hello", employeeID: 2, orderDate: nil, requiredDate: nil)
   * let ok = record.bind(to: statement, indices: ( 14, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_id >= 0 {
      sqlite3_bind_int64(statement, indices.idx_id, Int64(id))
    }
    return try NorthwindLighter.withOptCString(customerID) { ( s ) in
      if indices.idx_customerID >= 0 {
        sqlite3_bind_text(statement, indices.idx_customerID, s, -1, nil)
      }
      if indices.idx_employeeID >= 0 {
        if let employeeID = employeeID {
          sqlite3_bind_int64(statement, indices.idx_employeeID, Int64(employeeID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_employeeID)
        }
      }
      return try NorthwindLighter.withOptCString(orderDate) { ( s ) in
        if indices.idx_orderDate >= 0 {
          sqlite3_bind_text(statement, indices.idx_orderDate, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(requiredDate) { ( s ) in
          if indices.idx_requiredDate >= 0 {
            sqlite3_bind_text(statement, indices.idx_requiredDate, s, -1, nil)
          }
          return try NorthwindLighter.withOptCString(shippedDate) { ( s ) in
            if indices.idx_shippedDate >= 0 {
              sqlite3_bind_text(statement, indices.idx_shippedDate, s, -1, nil)
            }
            if indices.idx_shipVia >= 0 {
              if let shipVia = shipVia {
                sqlite3_bind_int64(statement, indices.idx_shipVia, Int64(shipVia))
              }
              else {
                sqlite3_bind_null(statement, indices.idx_shipVia)
              }
            }
            return try NorthwindLighter.withOptCString(freight) { ( s ) in
              if indices.idx_freight >= 0 {
                sqlite3_bind_text(statement, indices.idx_freight, s, -1, nil)
              }
              return try NorthwindLighter.withOptCString(shipName) { ( s ) in
                if indices.idx_shipName >= 0 {
                  sqlite3_bind_text(statement, indices.idx_shipName, s, -1, nil)
                }
                return try NorthwindLighter.withOptCString(shipAddress) { ( s ) in
                  if indices.idx_shipAddress >= 0 {
                    sqlite3_bind_text(statement, indices.idx_shipAddress, s, -1, nil)
                  }
                  return try NorthwindLighter.withOptCString(shipCity) { ( s ) in
                    if indices.idx_shipCity >= 0 {
                      sqlite3_bind_text(statement, indices.idx_shipCity, s, -1, nil)
                    }
                    return try NorthwindLighter.withOptCString(shipRegion) { ( s ) in
                      if indices.idx_shipRegion >= 0 {
                        sqlite3_bind_text(statement, indices.idx_shipRegion, s, -1, nil)
                      }
                      return try NorthwindLighter.withOptCString(shipPostalCode) { ( s ) in
                        if indices.idx_shipPostalCode >= 0 {
                          sqlite3_bind_text(statement, indices.idx_shipPostalCode, s, -1, nil)
                        }
                        return try NorthwindLighter.withOptCString(shipCountry) { ( s ) in
                          if indices.idx_shipCountry >= 0 {
                            sqlite3_bind_text(statement, indices.idx_shipCountry, s, -1, nil)
                          }
                          return try execute()
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.Product {
  
  /**
   * Static type information for the ``Product`` record (`Products` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_productName: Int32, idx_supplierID: Int32, idx_categoryID: Int32, idx_quantityPerUnit: Int32, idx_unitPrice: Int32, idx_unitsInStock: Int32, idx_unitsOnOrder: Int32, idx_reorderLevel: Int32, idx_discontinued: Int32 )
    public typealias RecordType = NorthwindLighter.Product
    
    /// The SQL table name associated with the ``Product`` record.
    public static let externalName = "Products"
    
    /// The number of columns the `Products` table has.
    public static let columnCount : Int32 = 10
    
    /// Information on the records primary key (``Product/id``).
    public static let primaryKeyColumn = MappedForeignKey<NorthwindLighter.Product, Int, MappedColumn<NorthwindLighter.Category, Int?>>(
      externalName: "ProductID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Product.id,
      destinationColumn: NorthwindLighter.Category.schema.id
    )
    
    /// SQL to `SELECT` all columns of the `Products` table.
    public static let select = #"SELECT "ProductID", "ProductName", "SupplierID", "CategoryID", "QuantityPerUnit", "UnitPrice", "UnitsInStock", "UnitsOnOrder", "ReorderLevel", "Discontinued" FROM "Products""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""ProductID", "ProductName", "SupplierID", "CategoryID", "QuantityPerUnit", "UnitPrice", "UnitsInStock", "UnitsOnOrder", "ReorderLevel", "Discontinued""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Products_id FROM Products`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Products_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "ProductID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
        else if strcmp(col!, "SupplierID") == 0 {
          indices.idx_supplierID = i
        }
        else if strcmp(col!, "CategoryID") == 0 {
          indices.idx_categoryID = i
        }
        else if strcmp(col!, "QuantityPerUnit") == 0 {
          indices.idx_quantityPerUnit = i
        }
        else if strcmp(col!, "UnitPrice") == 0 {
          indices.idx_unitPrice = i
        }
        else if strcmp(col!, "UnitsInStock") == 0 {
          indices.idx_unitsInStock = i
        }
        else if strcmp(col!, "UnitsOnOrder") == 0 {
          indices.idx_unitsOnOrder = i
        }
        else if strcmp(col!, "ReorderLevel") == 0 {
          indices.idx_reorderLevel = i
        }
        else if strcmp(col!, "Discontinued") == 0 {
          indices.idx_discontinued = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Product/id`` (`ProductID` column).
    public let id = MappedForeignKey<NorthwindLighter.Product, Int, MappedColumn<NorthwindLighter.Category, Int?>>(
      externalName: "ProductID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Product.id,
      destinationColumn: NorthwindLighter.Category.schema.id
    )
    
    /// Type information for property ``Product/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.Product, String>(
      externalName: "ProductName",
      defaultValue: "",
      keyPath: \NorthwindLighter.Product.productName
    )
    
    /// Type information for property ``Product/supplierID`` (`SupplierID` column).
    public let supplierID = MappedForeignKey<NorthwindLighter.Product, Int?, MappedColumn<NorthwindLighter.Supplier, Int>>(
      externalName: "SupplierID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Product.supplierID,
      destinationColumn: NorthwindLighter.Supplier.schema.id
    )
    
    /// Type information for property ``Product/categoryID`` (`CategoryID` column).
    public let categoryID = MappedColumn<NorthwindLighter.Product, Int?>(
      externalName: "CategoryID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Product.categoryID
    )
    
    /// Type information for property ``Product/quantityPerUnit`` (`QuantityPerUnit` column).
    public let quantityPerUnit = MappedColumn<NorthwindLighter.Product, String?>(
      externalName: "QuantityPerUnit",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Product.quantityPerUnit
    )
    
    /// Type information for property ``Product/unitPrice`` (`UnitPrice` column).
    public let unitPrice = MappedColumn<NorthwindLighter.Product, String?>(
      externalName: "UnitPrice",
      defaultValue: "0",
      keyPath: \NorthwindLighter.Product.unitPrice
    )
    
    /// Type information for property ``Product/unitsInStock`` (`UnitsInStock` column).
    public let unitsInStock = MappedColumn<NorthwindLighter.Product, Int?>(
      externalName: "UnitsInStock",
      defaultValue: 0,
      keyPath: \NorthwindLighter.Product.unitsInStock
    )
    
    /// Type information for property ``Product/unitsOnOrder`` (`UnitsOnOrder` column).
    public let unitsOnOrder = MappedColumn<NorthwindLighter.Product, Int?>(
      externalName: "UnitsOnOrder",
      defaultValue: 0,
      keyPath: \NorthwindLighter.Product.unitsOnOrder
    )
    
    /// Type information for property ``Product/reorderLevel`` (`ReorderLevel` column).
    public let reorderLevel = MappedColumn<NorthwindLighter.Product, Int?>(
      externalName: "ReorderLevel",
      defaultValue: 0,
      keyPath: \NorthwindLighter.Product.reorderLevel
    )
    
    /// Type information for property ``Product/discontinued`` (`Discontinued` column).
    public let discontinued = MappedColumn<NorthwindLighter.Product, String>(
      externalName: "Discontinued",
      defaultValue: "'0'",
      keyPath: \NorthwindLighter.Product.discontinued
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, productName, supplierID, categoryID, quantityPerUnit, unitPrice, unitsInStock, unitsOnOrder, reorderLevel, discontinued ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Product`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Products", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Product(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: (indices.idx_id >= 0) && (indices.idx_id < argc) && (sqlite3_column_type(statement, indices.idx_id) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_id)) : Self.schema.id.defaultValue,
      productName: ((indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : nil) ?? Self.schema.productName.defaultValue,
      supplierID: (indices.idx_supplierID >= 0) && (indices.idx_supplierID < argc) ? (sqlite3_column_type(statement, indices.idx_supplierID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_supplierID)) : nil) : Self.schema.supplierID.defaultValue,
      categoryID: (indices.idx_categoryID >= 0) && (indices.idx_categoryID < argc) ? (sqlite3_column_type(statement, indices.idx_categoryID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_categoryID)) : nil) : Self.schema.categoryID.defaultValue,
      quantityPerUnit: (indices.idx_quantityPerUnit >= 0) && (indices.idx_quantityPerUnit < argc) ? (sqlite3_column_text(statement, indices.idx_quantityPerUnit).flatMap(String.init(cString:))) : Self.schema.quantityPerUnit.defaultValue,
      unitPrice: (indices.idx_unitPrice >= 0) && (indices.idx_unitPrice < argc) ? (sqlite3_column_text(statement, indices.idx_unitPrice).flatMap(String.init(cString:))) : Self.schema.unitPrice.defaultValue,
      unitsInStock: (indices.idx_unitsInStock >= 0) && (indices.idx_unitsInStock < argc) ? (sqlite3_column_type(statement, indices.idx_unitsInStock) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_unitsInStock)) : nil) : Self.schema.unitsInStock.defaultValue,
      unitsOnOrder: (indices.idx_unitsOnOrder >= 0) && (indices.idx_unitsOnOrder < argc) ? (sqlite3_column_type(statement, indices.idx_unitsOnOrder) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_unitsOnOrder)) : nil) : Self.schema.unitsOnOrder.defaultValue,
      reorderLevel: (indices.idx_reorderLevel >= 0) && (indices.idx_reorderLevel < argc) ? (sqlite3_column_type(statement, indices.idx_reorderLevel) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_reorderLevel)) : nil) : Self.schema.reorderLevel.defaultValue,
      discontinued: ((indices.idx_discontinued >= 0) && (indices.idx_discontinued < argc) ? (sqlite3_column_text(statement, indices.idx_discontinued).flatMap(String.init(cString:))) : nil) ?? Self.schema.discontinued.defaultValue
    )
  }
  
  /**
   * Bind all ``Product`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Products" SET "ProductName" = ?, "SupplierID" = ?, "CategoryID" = ?, "QuantityPerUnit" = ?, "UnitPrice" = ?, "UnitsInStock" = ?, "UnitsOnOrder" = ?, "ReorderLevel" = ?, "Discontinued" = ? WHERE "ProductID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Product(id: 1, productName: "Hello", supplierID: 2, categoryID: 3, quantityPerUnit: "World", unitPrice: "Duck", discontinued: "Donald")
   * let ok = record.bind(to: statement, indices: ( 10, 1, 2, 3, 4, 5, 6, 7, 8, 9 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_id >= 0 {
      sqlite3_bind_int64(statement, indices.idx_id, Int64(id))
    }
    return try productName.withCString() { ( s ) in
      if indices.idx_productName >= 0 {
        sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
      }
      if indices.idx_supplierID >= 0 {
        if let supplierID = supplierID {
          sqlite3_bind_int64(statement, indices.idx_supplierID, Int64(supplierID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_supplierID)
        }
      }
      if indices.idx_categoryID >= 0 {
        if let categoryID = categoryID {
          sqlite3_bind_int64(statement, indices.idx_categoryID, Int64(categoryID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_categoryID)
        }
      }
      return try NorthwindLighter.withOptCString(quantityPerUnit) { ( s ) in
        if indices.idx_quantityPerUnit >= 0 {
          sqlite3_bind_text(statement, indices.idx_quantityPerUnit, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(unitPrice) { ( s ) in
          if indices.idx_unitPrice >= 0 {
            sqlite3_bind_text(statement, indices.idx_unitPrice, s, -1, nil)
          }
          if indices.idx_unitsInStock >= 0 {
            if let unitsInStock = unitsInStock {
              sqlite3_bind_int64(statement, indices.idx_unitsInStock, Int64(unitsInStock))
            }
            else {
              sqlite3_bind_null(statement, indices.idx_unitsInStock)
            }
          }
          if indices.idx_unitsOnOrder >= 0 {
            if let unitsOnOrder = unitsOnOrder {
              sqlite3_bind_int64(statement, indices.idx_unitsOnOrder, Int64(unitsOnOrder))
            }
            else {
              sqlite3_bind_null(statement, indices.idx_unitsOnOrder)
            }
          }
          if indices.idx_reorderLevel >= 0 {
            if let reorderLevel = reorderLevel {
              sqlite3_bind_int64(statement, indices.idx_reorderLevel, Int64(reorderLevel))
            }
            else {
              sqlite3_bind_null(statement, indices.idx_reorderLevel)
            }
          }
          return try discontinued.withCString() { ( s ) in
            if indices.idx_discontinued >= 0 {
              sqlite3_bind_text(statement, indices.idx_discontinued, s, -1, nil)
            }
            return try execute()
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.Region {
  
  /**
   * Static type information for the ``Region`` record (`Regions` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_regionDescription: Int32 )
    public typealias RecordType = NorthwindLighter.Region
    
    /// The SQL table name associated with the ``Region`` record.
    public static let externalName = "Regions"
    
    /// The number of columns the `Regions` table has.
    public static let columnCount : Int32 = 2
    
    /// Information on the records primary key (``Region/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.Region, Int>(
      externalName: "RegionID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Region.id
    )
    
    /// SQL to `SELECT` all columns of the `Regions` table.
    public static let select = #"SELECT "RegionID", "RegionDescription" FROM "Regions""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""RegionID", "RegionDescription""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Regions_id FROM Regions`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Regions_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "RegionID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "RegionDescription") == 0 {
          indices.idx_regionDescription = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Region/id`` (`RegionID` column).
    public let id = MappedColumn<NorthwindLighter.Region, Int>(
      externalName: "RegionID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Region.id
    )
    
    /// Type information for property ``Region/regionDescription`` (`RegionDescription` column).
    public let regionDescription = MappedColumn<NorthwindLighter.Region, String>(
      externalName: "RegionDescription",
      defaultValue: "",
      keyPath: \NorthwindLighter.Region.regionDescription
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, regionDescription ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Region`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Regions", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Region(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: (indices.idx_id >= 0) && (indices.idx_id < argc) && (sqlite3_column_type(statement, indices.idx_id) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_id)) : Self.schema.id.defaultValue,
      regionDescription: ((indices.idx_regionDescription >= 0) && (indices.idx_regionDescription < argc) ? (sqlite3_column_text(statement, indices.idx_regionDescription).flatMap(String.init(cString:))) : nil) ?? Self.schema.regionDescription.defaultValue
    )
  }
  
  /**
   * Bind all ``Region`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Regions" SET "RegionDescription" = ? WHERE "RegionID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Region(id: 1, regionDescription: "Hello")
   * let ok = record.bind(to: statement, indices: ( 2, 1 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_id >= 0 {
      sqlite3_bind_int64(statement, indices.idx_id, Int64(id))
    }
    return try regionDescription.withCString() { ( s ) in
      if indices.idx_regionDescription >= 0 {
        sqlite3_bind_text(statement, indices.idx_regionDescription, s, -1, nil)
      }
      return try execute()
    }
  }
}

public extension NorthwindLighter.Shipper {
  
  /**
   * Static type information for the ``Shipper`` record (`Shippers` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_companyName: Int32, idx_phone: Int32 )
    public typealias RecordType = NorthwindLighter.Shipper
    
    /// The SQL table name associated with the ``Shipper`` record.
    public static let externalName = "Shippers"
    
    /// The number of columns the `Shippers` table has.
    public static let columnCount : Int32 = 3
    
    /// Information on the records primary key (``Shipper/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.Shipper, Int>(
      externalName: "ShipperID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Shipper.id
    )
    
    /// SQL to `SELECT` all columns of the `Shippers` table.
    public static let select = #"SELECT "ShipperID", "CompanyName", "Phone" FROM "Shippers""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""ShipperID", "CompanyName", "Phone""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Shippers_id FROM Shippers`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Shippers_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "ShipperID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "CompanyName") == 0 {
          indices.idx_companyName = i
        }
        else if strcmp(col!, "Phone") == 0 {
          indices.idx_phone = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Shipper/id`` (`ShipperID` column).
    public let id = MappedColumn<NorthwindLighter.Shipper, Int>(
      externalName: "ShipperID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Shipper.id
    )
    
    /// Type information for property ``Shipper/companyName`` (`CompanyName` column).
    public let companyName = MappedColumn<NorthwindLighter.Shipper, String>(
      externalName: "CompanyName",
      defaultValue: "",
      keyPath: \NorthwindLighter.Shipper.companyName
    )
    
    /// Type information for property ``Shipper/phone`` (`Phone` column).
    public let phone = MappedColumn<NorthwindLighter.Shipper, String?>(
      externalName: "Phone",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Shipper.phone
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, companyName, phone ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Shipper`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Shippers", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Shipper(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: (indices.idx_id >= 0) && (indices.idx_id < argc) && (sqlite3_column_type(statement, indices.idx_id) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_id)) : Self.schema.id.defaultValue,
      companyName: ((indices.idx_companyName >= 0) && (indices.idx_companyName < argc) ? (sqlite3_column_text(statement, indices.idx_companyName).flatMap(String.init(cString:))) : nil) ?? Self.schema.companyName.defaultValue,
      phone: (indices.idx_phone >= 0) && (indices.idx_phone < argc) ? (sqlite3_column_text(statement, indices.idx_phone).flatMap(String.init(cString:))) : Self.schema.phone.defaultValue
    )
  }
  
  /**
   * Bind all ``Shipper`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Shippers" SET "CompanyName" = ?, "Phone" = ? WHERE "ShipperID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Shipper(id: 1, companyName: "Hello", phone: "World")
   * let ok = record.bind(to: statement, indices: ( 3, 1, 2 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_id >= 0 {
      sqlite3_bind_int64(statement, indices.idx_id, Int64(id))
    }
    return try companyName.withCString() { ( s ) in
      if indices.idx_companyName >= 0 {
        sqlite3_bind_text(statement, indices.idx_companyName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(phone) { ( s ) in
        if indices.idx_phone >= 0 {
          sqlite3_bind_text(statement, indices.idx_phone, s, -1, nil)
        }
        return try execute()
      }
    }
  }
}

public extension NorthwindLighter.Supplier {
  
  /**
   * Static type information for the ``Supplier`` record (`Suppliers` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_companyName: Int32, idx_contactName: Int32, idx_contactTitle: Int32, idx_address: Int32, idx_city: Int32, idx_region: Int32, idx_postalCode: Int32, idx_country: Int32, idx_phone: Int32, idx_fax: Int32, idx_homePage: Int32 )
    public typealias RecordType = NorthwindLighter.Supplier
    
    /// The SQL table name associated with the ``Supplier`` record.
    public static let externalName = "Suppliers"
    
    /// The number of columns the `Suppliers` table has.
    public static let columnCount : Int32 = 12
    
    /// Information on the records primary key (``Supplier/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.Supplier, Int>(
      externalName: "SupplierID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Supplier.id
    )
    
    /// SQL to `SELECT` all columns of the `Suppliers` table.
    public static let select = #"SELECT "SupplierID", "CompanyName", "ContactName", "ContactTitle", "Address", "City", "Region", "PostalCode", "Country", "Phone", "Fax", "HomePage" FROM "Suppliers""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""SupplierID", "CompanyName", "ContactName", "ContactTitle", "Address", "City", "Region", "PostalCode", "Country", "Phone", "Fax", "HomePage""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Suppliers_id FROM Suppliers`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Suppliers_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "SupplierID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "CompanyName") == 0 {
          indices.idx_companyName = i
        }
        else if strcmp(col!, "ContactName") == 0 {
          indices.idx_contactName = i
        }
        else if strcmp(col!, "ContactTitle") == 0 {
          indices.idx_contactTitle = i
        }
        else if strcmp(col!, "Address") == 0 {
          indices.idx_address = i
        }
        else if strcmp(col!, "City") == 0 {
          indices.idx_city = i
        }
        else if strcmp(col!, "Region") == 0 {
          indices.idx_region = i
        }
        else if strcmp(col!, "PostalCode") == 0 {
          indices.idx_postalCode = i
        }
        else if strcmp(col!, "Country") == 0 {
          indices.idx_country = i
        }
        else if strcmp(col!, "Phone") == 0 {
          indices.idx_phone = i
        }
        else if strcmp(col!, "Fax") == 0 {
          indices.idx_fax = i
        }
        else if strcmp(col!, "HomePage") == 0 {
          indices.idx_homePage = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Supplier/id`` (`SupplierID` column).
    public let id = MappedColumn<NorthwindLighter.Supplier, Int>(
      externalName: "SupplierID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Supplier.id
    )
    
    /// Type information for property ``Supplier/companyName`` (`CompanyName` column).
    public let companyName = MappedColumn<NorthwindLighter.Supplier, String>(
      externalName: "CompanyName",
      defaultValue: "",
      keyPath: \NorthwindLighter.Supplier.companyName
    )
    
    /// Type information for property ``Supplier/contactName`` (`ContactName` column).
    public let contactName = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "ContactName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.contactName
    )
    
    /// Type information for property ``Supplier/contactTitle`` (`ContactTitle` column).
    public let contactTitle = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "ContactTitle",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.contactTitle
    )
    
    /// Type information for property ``Supplier/address`` (`Address` column).
    public let address = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "Address",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.address
    )
    
    /// Type information for property ``Supplier/city`` (`City` column).
    public let city = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "City",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.city
    )
    
    /// Type information for property ``Supplier/region`` (`Region` column).
    public let region = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "Region",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.region
    )
    
    /// Type information for property ``Supplier/postalCode`` (`PostalCode` column).
    public let postalCode = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "PostalCode",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.postalCode
    )
    
    /// Type information for property ``Supplier/country`` (`Country` column).
    public let country = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "Country",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.country
    )
    
    /// Type information for property ``Supplier/phone`` (`Phone` column).
    public let phone = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "Phone",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.phone
    )
    
    /// Type information for property ``Supplier/fax`` (`Fax` column).
    public let fax = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "Fax",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.fax
    )
    
    /// Type information for property ``Supplier/homePage`` (`HomePage` column).
    public let homePage = MappedColumn<NorthwindLighter.Supplier, String?>(
      externalName: "HomePage",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Supplier.homePage
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, companyName, contactName, contactTitle, address, city, region, postalCode, country, phone, fax, homePage ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Supplier`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Suppliers", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Supplier(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: (indices.idx_id >= 0) && (indices.idx_id < argc) && (sqlite3_column_type(statement, indices.idx_id) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_id)) : Self.schema.id.defaultValue,
      companyName: ((indices.idx_companyName >= 0) && (indices.idx_companyName < argc) ? (sqlite3_column_text(statement, indices.idx_companyName).flatMap(String.init(cString:))) : nil) ?? Self.schema.companyName.defaultValue,
      contactName: (indices.idx_contactName >= 0) && (indices.idx_contactName < argc) ? (sqlite3_column_text(statement, indices.idx_contactName).flatMap(String.init(cString:))) : Self.schema.contactName.defaultValue,
      contactTitle: (indices.idx_contactTitle >= 0) && (indices.idx_contactTitle < argc) ? (sqlite3_column_text(statement, indices.idx_contactTitle).flatMap(String.init(cString:))) : Self.schema.contactTitle.defaultValue,
      address: (indices.idx_address >= 0) && (indices.idx_address < argc) ? (sqlite3_column_text(statement, indices.idx_address).flatMap(String.init(cString:))) : Self.schema.address.defaultValue,
      city: (indices.idx_city >= 0) && (indices.idx_city < argc) ? (sqlite3_column_text(statement, indices.idx_city).flatMap(String.init(cString:))) : Self.schema.city.defaultValue,
      region: (indices.idx_region >= 0) && (indices.idx_region < argc) ? (sqlite3_column_text(statement, indices.idx_region).flatMap(String.init(cString:))) : Self.schema.region.defaultValue,
      postalCode: (indices.idx_postalCode >= 0) && (indices.idx_postalCode < argc) ? (sqlite3_column_text(statement, indices.idx_postalCode).flatMap(String.init(cString:))) : Self.schema.postalCode.defaultValue,
      country: (indices.idx_country >= 0) && (indices.idx_country < argc) ? (sqlite3_column_text(statement, indices.idx_country).flatMap(String.init(cString:))) : Self.schema.country.defaultValue,
      phone: (indices.idx_phone >= 0) && (indices.idx_phone < argc) ? (sqlite3_column_text(statement, indices.idx_phone).flatMap(String.init(cString:))) : Self.schema.phone.defaultValue,
      fax: (indices.idx_fax >= 0) && (indices.idx_fax < argc) ? (sqlite3_column_text(statement, indices.idx_fax).flatMap(String.init(cString:))) : Self.schema.fax.defaultValue,
      homePage: (indices.idx_homePage >= 0) && (indices.idx_homePage < argc) ? (sqlite3_column_text(statement, indices.idx_homePage).flatMap(String.init(cString:))) : Self.schema.homePage.defaultValue
    )
  }
  
  /**
   * Bind all ``Supplier`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Suppliers" SET "CompanyName" = ?, "ContactName" = ?, "ContactTitle" = ?, "Address" = ?, "City" = ?, "Region" = ?, "PostalCode" = ?, "Country" = ?, "Phone" = ?, "Fax" = ?, "HomePage" = ? WHERE "SupplierID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Supplier(id: 1, companyName: "Hello", contactName: "World", contactTitle: "Duck", address: "Donald", city: "Mickey")
   * let ok = record.bind(to: statement, indices: ( 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_id >= 0 {
      sqlite3_bind_int64(statement, indices.idx_id, Int64(id))
    }
    return try companyName.withCString() { ( s ) in
      if indices.idx_companyName >= 0 {
        sqlite3_bind_text(statement, indices.idx_companyName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(contactName) { ( s ) in
        if indices.idx_contactName >= 0 {
          sqlite3_bind_text(statement, indices.idx_contactName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(contactTitle) { ( s ) in
          if indices.idx_contactTitle >= 0 {
            sqlite3_bind_text(statement, indices.idx_contactTitle, s, -1, nil)
          }
          return try NorthwindLighter.withOptCString(address) { ( s ) in
            if indices.idx_address >= 0 {
              sqlite3_bind_text(statement, indices.idx_address, s, -1, nil)
            }
            return try NorthwindLighter.withOptCString(city) { ( s ) in
              if indices.idx_city >= 0 {
                sqlite3_bind_text(statement, indices.idx_city, s, -1, nil)
              }
              return try NorthwindLighter.withOptCString(region) { ( s ) in
                if indices.idx_region >= 0 {
                  sqlite3_bind_text(statement, indices.idx_region, s, -1, nil)
                }
                return try NorthwindLighter.withOptCString(postalCode) { ( s ) in
                  if indices.idx_postalCode >= 0 {
                    sqlite3_bind_text(statement, indices.idx_postalCode, s, -1, nil)
                  }
                  return try NorthwindLighter.withOptCString(country) { ( s ) in
                    if indices.idx_country >= 0 {
                      sqlite3_bind_text(statement, indices.idx_country, s, -1, nil)
                    }
                    return try NorthwindLighter.withOptCString(phone) { ( s ) in
                      if indices.idx_phone >= 0 {
                        sqlite3_bind_text(statement, indices.idx_phone, s, -1, nil)
                      }
                      return try NorthwindLighter.withOptCString(fax) { ( s ) in
                        if indices.idx_fax >= 0 {
                          sqlite3_bind_text(statement, indices.idx_fax, s, -1, nil)
                        }
                        return try NorthwindLighter.withOptCString(homePage) { ( s ) in
                          if indices.idx_homePage >= 0 {
                            sqlite3_bind_text(statement, indices.idx_homePage, s, -1, nil)
                          }
                          return try execute()
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.Territory {
  
  /**
   * Static type information for the ``Territory`` record (`Territories` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLKeyedTableSchema {
    
    public typealias PropertyIndices = ( idx_id: Int32, idx_territoryDescription: Int32, idx_regionID: Int32 )
    public typealias RecordType = NorthwindLighter.Territory
    
    /// The SQL table name associated with the ``Territory`` record.
    public static let externalName = "Territories"
    
    /// The number of columns the `Territories` table has.
    public static let columnCount : Int32 = 3
    
    /// Information on the records primary key (``Territory/id``).
    public static let primaryKeyColumn = MappedColumn<NorthwindLighter.Territory, String>(
      externalName: "TerritoryID",
      defaultValue: "",
      keyPath: \NorthwindLighter.Territory.id
    )
    
    /// SQL to `SELECT` all columns of the `Territories` table.
    public static let select = #"SELECT "TerritoryID", "TerritoryDescription", "RegionID" FROM "Territories""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""TerritoryID", "TerritoryDescription", "RegionID""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2 )
    
    /// *Note*: Readonly database, do not use.
    public static let update = ""
    
    /// *Note*: Readonly database, do not use.
    public static let updateParameterIndices : PropertyIndices = ( -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let insert = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertReturning = ""
    
    /// *Note*: Readonly database, do not use.
    public static let insertParameterIndices : PropertyIndices = ( -1, -1, -1 )
    
    /// *Note*: Readonly database, do not use.
    public static let delete = ""
    
    /// *Note*: Readonly database, do not use.
    public static let deleteParameterIndices : PropertyIndices = ( -1, -1, -1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Territories_id FROM Territories`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Territories_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "TerritoryID") == 0 {
          indices.idx_id = i
        }
        else if strcmp(col!, "TerritoryDescription") == 0 {
          indices.idx_territoryDescription = i
        }
        else if strcmp(col!, "RegionID") == 0 {
          indices.idx_regionID = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Territory/id`` (`TerritoryID` column).
    public let id = MappedColumn<NorthwindLighter.Territory, String>(
      externalName: "TerritoryID",
      defaultValue: "",
      keyPath: \NorthwindLighter.Territory.id
    )
    
    /// Type information for property ``Territory/territoryDescription`` (`TerritoryDescription` column).
    public let territoryDescription = MappedColumn<NorthwindLighter.Territory, String>(
      externalName: "TerritoryDescription",
      defaultValue: "",
      keyPath: \NorthwindLighter.Territory.territoryDescription
    )
    
    /// Type information for property ``Territory/regionID`` (`RegionID` column).
    public let regionID = MappedForeignKey<NorthwindLighter.Territory, Int, MappedColumn<NorthwindLighter.Region, Int>>(
      externalName: "RegionID",
      defaultValue: -1,
      keyPath: \NorthwindLighter.Territory.regionID,
      destinationColumn: NorthwindLighter.Region.schema.id
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ id, territoryDescription, regionID ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Territory`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Territories", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Territory(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      id: ((indices.idx_id >= 0) && (indices.idx_id < argc) ? (sqlite3_column_text(statement, indices.idx_id).flatMap(String.init(cString:))) : nil) ?? Self.schema.id.defaultValue,
      territoryDescription: ((indices.idx_territoryDescription >= 0) && (indices.idx_territoryDescription < argc) ? (sqlite3_column_text(statement, indices.idx_territoryDescription).flatMap(String.init(cString:))) : nil) ?? Self.schema.territoryDescription.defaultValue,
      regionID: (indices.idx_regionID >= 0) && (indices.idx_regionID < argc) && (sqlite3_column_type(statement, indices.idx_regionID) != SQLITE_NULL) ? Int(sqlite3_column_int64(statement, indices.idx_regionID)) : Self.schema.regionID.defaultValue
    )
  }
  
  /**
   * Bind all ``Territory`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE "Territories" SET "TerritoryDescription" = ?, "RegionID" = ? WHERE "TerritoryID" = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Territory(id: "Hello", territoryDescription: "World", regionID: 1)
   * let ok = record.bind(to: statement, indices: ( 3, 1, 2 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try id.withCString() { ( s ) in
      if indices.idx_id >= 0 {
        sqlite3_bind_text(statement, indices.idx_id, s, -1, nil)
      }
      return try territoryDescription.withCString() { ( s ) in
        if indices.idx_territoryDescription >= 0 {
          sqlite3_bind_text(statement, indices.idx_territoryDescription, s, -1, nil)
        }
        if indices.idx_regionID >= 0 {
          sqlite3_bind_int64(statement, indices.idx_regionID, Int64(regionID))
        }
        return try execute()
      }
    }
  }
}

public extension NorthwindLighter.AlphabeticalListOfProduct {
  
  /**
   * Static type information for the ``AlphabeticalListOfProduct`` record (`Alphabetical list of products` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_productID: Int32, idx_productName: Int32, idx_supplierID: Int32, idx_categoryID: Int32, idx_quantityPerUnit: Int32, idx_unitPrice: Int32, idx_unitsInStock: Int32, idx_unitsOnOrder: Int32, idx_reorderLevel: Int32, idx_discontinued: Int32, idx_categoryName: Int32 )
    public typealias RecordType = NorthwindLighter.AlphabeticalListOfProduct
    
    /// The SQL table name associated with the ``AlphabeticalListOfProduct`` record.
    public static let externalName = "Alphabetical list of products"
    
    /// The number of columns the `Alphabetical list of products` table has.
    public static let columnCount : Int32 = 11
    
    /// SQL to `SELECT` all columns of the `Alphabetical list of products` table.
    public static let select = #"SELECT "ProductID", "ProductName", "SupplierID", "CategoryID", "QuantityPerUnit", "UnitPrice", "UnitsInStock", "UnitsOnOrder", "ReorderLevel", "Discontinued", "CategoryName" FROM "Alphabetical list of products""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""ProductID", "ProductName", "SupplierID", "CategoryID", "QuantityPerUnit", "UnitPrice", "UnitsInStock", "UnitsOnOrder", "ReorderLevel", "Discontinued", "CategoryName""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Alphabetical list of products_id FROM Alphabetical list of products`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Alphabetical list of products_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "ProductID") == 0 {
          indices.idx_productID = i
        }
        else if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
        else if strcmp(col!, "SupplierID") == 0 {
          indices.idx_supplierID = i
        }
        else if strcmp(col!, "CategoryID") == 0 {
          indices.idx_categoryID = i
        }
        else if strcmp(col!, "QuantityPerUnit") == 0 {
          indices.idx_quantityPerUnit = i
        }
        else if strcmp(col!, "UnitPrice") == 0 {
          indices.idx_unitPrice = i
        }
        else if strcmp(col!, "UnitsInStock") == 0 {
          indices.idx_unitsInStock = i
        }
        else if strcmp(col!, "UnitsOnOrder") == 0 {
          indices.idx_unitsOnOrder = i
        }
        else if strcmp(col!, "ReorderLevel") == 0 {
          indices.idx_reorderLevel = i
        }
        else if strcmp(col!, "Discontinued") == 0 {
          indices.idx_discontinued = i
        }
        else if strcmp(col!, "CategoryName") == 0 {
          indices.idx_categoryName = i
        }
      }
      return indices
    }
    
    /// Type information for property ``AlphabeticalListOfProduct/productID`` (`ProductID` column).
    public let productID = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, Int?>(
      externalName: "ProductID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.productID
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, String?>(
      externalName: "ProductName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.productName
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/supplierID`` (`SupplierID` column).
    public let supplierID = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, Int?>(
      externalName: "SupplierID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.supplierID
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/categoryID`` (`CategoryID` column).
    public let categoryID = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, Int?>(
      externalName: "CategoryID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.categoryID
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/quantityPerUnit`` (`QuantityPerUnit` column).
    public let quantityPerUnit = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, String?>(
      externalName: "QuantityPerUnit",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.quantityPerUnit
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/unitPrice`` (`UnitPrice` column).
    public let unitPrice = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, String?>(
      externalName: "UnitPrice",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.unitPrice
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/unitsInStock`` (`UnitsInStock` column).
    public let unitsInStock = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, Int?>(
      externalName: "UnitsInStock",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.unitsInStock
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/unitsOnOrder`` (`UnitsOnOrder` column).
    public let unitsOnOrder = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, Int?>(
      externalName: "UnitsOnOrder",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.unitsOnOrder
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/reorderLevel`` (`ReorderLevel` column).
    public let reorderLevel = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, Int?>(
      externalName: "ReorderLevel",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.reorderLevel
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/discontinued`` (`Discontinued` column).
    public let discontinued = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, String?>(
      externalName: "Discontinued",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.discontinued
    )
    
    /// Type information for property ``AlphabeticalListOfProduct/categoryName`` (`CategoryName` column).
    public let categoryName = MappedColumn<NorthwindLighter.AlphabeticalListOfProduct, String?>(
      externalName: "CategoryName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.AlphabeticalListOfProduct.categoryName
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ productID, productName, supplierID, categoryID, quantityPerUnit, unitPrice, unitsInStock, unitsOnOrder, reorderLevel, discontinued, categoryName ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``AlphabeticalListOfProduct`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Alphabetical list of products", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = AlphabeticalListOfProduct(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      productID: (indices.idx_productID >= 0) && (indices.idx_productID < argc) ? (sqlite3_column_type(statement, indices.idx_productID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_productID)) : nil) : Self.schema.productID.defaultValue,
      productName: (indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : Self.schema.productName.defaultValue,
      supplierID: (indices.idx_supplierID >= 0) && (indices.idx_supplierID < argc) ? (sqlite3_column_type(statement, indices.idx_supplierID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_supplierID)) : nil) : Self.schema.supplierID.defaultValue,
      categoryID: (indices.idx_categoryID >= 0) && (indices.idx_categoryID < argc) ? (sqlite3_column_type(statement, indices.idx_categoryID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_categoryID)) : nil) : Self.schema.categoryID.defaultValue,
      quantityPerUnit: (indices.idx_quantityPerUnit >= 0) && (indices.idx_quantityPerUnit < argc) ? (sqlite3_column_text(statement, indices.idx_quantityPerUnit).flatMap(String.init(cString:))) : Self.schema.quantityPerUnit.defaultValue,
      unitPrice: (indices.idx_unitPrice >= 0) && (indices.idx_unitPrice < argc) ? (sqlite3_column_text(statement, indices.idx_unitPrice).flatMap(String.init(cString:))) : Self.schema.unitPrice.defaultValue,
      unitsInStock: (indices.idx_unitsInStock >= 0) && (indices.idx_unitsInStock < argc) ? (sqlite3_column_type(statement, indices.idx_unitsInStock) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_unitsInStock)) : nil) : Self.schema.unitsInStock.defaultValue,
      unitsOnOrder: (indices.idx_unitsOnOrder >= 0) && (indices.idx_unitsOnOrder < argc) ? (sqlite3_column_type(statement, indices.idx_unitsOnOrder) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_unitsOnOrder)) : nil) : Self.schema.unitsOnOrder.defaultValue,
      reorderLevel: (indices.idx_reorderLevel >= 0) && (indices.idx_reorderLevel < argc) ? (sqlite3_column_type(statement, indices.idx_reorderLevel) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_reorderLevel)) : nil) : Self.schema.reorderLevel.defaultValue,
      discontinued: (indices.idx_discontinued >= 0) && (indices.idx_discontinued < argc) ? (sqlite3_column_text(statement, indices.idx_discontinued).flatMap(String.init(cString:))) : Self.schema.discontinued.defaultValue,
      categoryName: (indices.idx_categoryName >= 0) && (indices.idx_categoryName < argc) ? (sqlite3_column_text(statement, indices.idx_categoryName).flatMap(String.init(cString:))) : Self.schema.categoryName.defaultValue
    )
  }
  
  /**
   * Bind all ``AlphabeticalListOfProduct`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Alphabetical list of products SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = AlphabeticalListOfProduct(productID: 1, productName: "Hello", supplierID: 2, categoryID: 3)
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_productID >= 0 {
      if let productID = productID {
        sqlite3_bind_int64(statement, indices.idx_productID, Int64(productID))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_productID)
      }
    }
    return try NorthwindLighter.withOptCString(productName) { ( s ) in
      if indices.idx_productName >= 0 {
        sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
      }
      if indices.idx_supplierID >= 0 {
        if let supplierID = supplierID {
          sqlite3_bind_int64(statement, indices.idx_supplierID, Int64(supplierID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_supplierID)
        }
      }
      if indices.idx_categoryID >= 0 {
        if let categoryID = categoryID {
          sqlite3_bind_int64(statement, indices.idx_categoryID, Int64(categoryID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_categoryID)
        }
      }
      return try NorthwindLighter.withOptCString(quantityPerUnit) { ( s ) in
        if indices.idx_quantityPerUnit >= 0 {
          sqlite3_bind_text(statement, indices.idx_quantityPerUnit, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(unitPrice) { ( s ) in
          if indices.idx_unitPrice >= 0 {
            sqlite3_bind_text(statement, indices.idx_unitPrice, s, -1, nil)
          }
          if indices.idx_unitsInStock >= 0 {
            if let unitsInStock = unitsInStock {
              sqlite3_bind_int64(statement, indices.idx_unitsInStock, Int64(unitsInStock))
            }
            else {
              sqlite3_bind_null(statement, indices.idx_unitsInStock)
            }
          }
          if indices.idx_unitsOnOrder >= 0 {
            if let unitsOnOrder = unitsOnOrder {
              sqlite3_bind_int64(statement, indices.idx_unitsOnOrder, Int64(unitsOnOrder))
            }
            else {
              sqlite3_bind_null(statement, indices.idx_unitsOnOrder)
            }
          }
          if indices.idx_reorderLevel >= 0 {
            if let reorderLevel = reorderLevel {
              sqlite3_bind_int64(statement, indices.idx_reorderLevel, Int64(reorderLevel))
            }
            else {
              sqlite3_bind_null(statement, indices.idx_reorderLevel)
            }
          }
          return try NorthwindLighter.withOptCString(discontinued) { ( s ) in
            if indices.idx_discontinued >= 0 {
              sqlite3_bind_text(statement, indices.idx_discontinued, s, -1, nil)
            }
            return try NorthwindLighter.withOptCString(categoryName) { ( s ) in
              if indices.idx_categoryName >= 0 {
                sqlite3_bind_text(statement, indices.idx_categoryName, s, -1, nil)
              }
              return try execute()
            }
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.CurrentProductList {
  
  /**
   * Static type information for the ``CurrentProductList`` record (`Current Product List` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_productID: Int32, idx_productName: Int32 )
    public typealias RecordType = NorthwindLighter.CurrentProductList
    
    /// The SQL table name associated with the ``CurrentProductList`` record.
    public static let externalName = "Current Product List"
    
    /// The number of columns the `Current Product List` table has.
    public static let columnCount : Int32 = 2
    
    /// SQL to `SELECT` all columns of the `Current Product List` table.
    public static let select = #"SELECT "ProductID", "ProductName" FROM "Current Product List""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""ProductID", "ProductName""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Current Product List_id FROM Current Product List`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Current Product List_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "ProductID") == 0 {
          indices.idx_productID = i
        }
        else if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
      }
      return indices
    }
    
    /// Type information for property ``CurrentProductList/productID`` (`ProductID` column).
    public let productID = MappedColumn<NorthwindLighter.CurrentProductList, Int?>(
      externalName: "ProductID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CurrentProductList.productID
    )
    
    /// Type information for property ``CurrentProductList/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.CurrentProductList, String?>(
      externalName: "ProductName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CurrentProductList.productName
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ productID, productName ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``CurrentProductList`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Current Product List", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = CurrentProductList(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      productID: (indices.idx_productID >= 0) && (indices.idx_productID < argc) ? (sqlite3_column_type(statement, indices.idx_productID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_productID)) : nil) : Self.schema.productID.defaultValue,
      productName: (indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : Self.schema.productName.defaultValue
    )
  }
  
  /**
   * Bind all ``CurrentProductList`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Current Product List SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = CurrentProductList(productID: 1, productName: "Hello")
   * let ok = record.bind(to: statement, indices: ( 1, 2 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_productID >= 0 {
      if let productID = productID {
        sqlite3_bind_int64(statement, indices.idx_productID, Int64(productID))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_productID)
      }
    }
    return try NorthwindLighter.withOptCString(productName) { ( s ) in
      if indices.idx_productName >= 0 {
        sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
      }
      return try execute()
    }
  }
}

public extension NorthwindLighter.CustomerAndSuppliersByCity {
  
  /**
   * Static type information for the ``CustomerAndSuppliersByCity`` record (`Customer and Suppliers by City` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_city: Int32, idx_companyName: Int32, idx_contactName: Int32, idx_relationship: Int32 )
    public typealias RecordType = NorthwindLighter.CustomerAndSuppliersByCity
    
    /// The SQL table name associated with the ``CustomerAndSuppliersByCity`` record.
    public static let externalName = "Customer and Suppliers by City"
    
    /// The number of columns the `Customer and Suppliers by City` table has.
    public static let columnCount : Int32 = 4
    
    /// SQL to `SELECT` all columns of the `Customer and Suppliers by City` table.
    public static let select = #"SELECT "City", "CompanyName", "ContactName", "Relationship" FROM "Customer and Suppliers by City""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""City", "CompanyName", "ContactName", "Relationship""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Customer and Suppliers by City_id FROM Customer and Suppliers by City`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Customer and Suppliers by City_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "City") == 0 {
          indices.idx_city = i
        }
        else if strcmp(col!, "CompanyName") == 0 {
          indices.idx_companyName = i
        }
        else if strcmp(col!, "ContactName") == 0 {
          indices.idx_contactName = i
        }
        else if strcmp(col!, "Relationship") == 0 {
          indices.idx_relationship = i
        }
      }
      return indices
    }
    
    /// Type information for property ``CustomerAndSuppliersByCity/city`` (`City` column).
    public let city = MappedColumn<NorthwindLighter.CustomerAndSuppliersByCity, String?>(
      externalName: "City",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CustomerAndSuppliersByCity.city
    )
    
    /// Type information for property ``CustomerAndSuppliersByCity/companyName`` (`CompanyName` column).
    public let companyName = MappedColumn<NorthwindLighter.CustomerAndSuppliersByCity, String?>(
      externalName: "CompanyName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CustomerAndSuppliersByCity.companyName
    )
    
    /// Type information for property ``CustomerAndSuppliersByCity/contactName`` (`ContactName` column).
    public let contactName = MappedColumn<NorthwindLighter.CustomerAndSuppliersByCity, String?>(
      externalName: "ContactName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CustomerAndSuppliersByCity.contactName
    )
    
    /// Type information for property ``CustomerAndSuppliersByCity/relationship`` (`Relationship` column).
    public let relationship = MappedColumn<NorthwindLighter.CustomerAndSuppliersByCity, String?>(
      externalName: "Relationship",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CustomerAndSuppliersByCity.relationship
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ city, companyName, contactName, relationship ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``CustomerAndSuppliersByCity`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Customer and Suppliers by City", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = CustomerAndSuppliersByCity(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      city: (indices.idx_city >= 0) && (indices.idx_city < argc) ? (sqlite3_column_text(statement, indices.idx_city).flatMap(String.init(cString:))) : Self.schema.city.defaultValue,
      companyName: (indices.idx_companyName >= 0) && (indices.idx_companyName < argc) ? (sqlite3_column_text(statement, indices.idx_companyName).flatMap(String.init(cString:))) : Self.schema.companyName.defaultValue,
      contactName: (indices.idx_contactName >= 0) && (indices.idx_contactName < argc) ? (sqlite3_column_text(statement, indices.idx_contactName).flatMap(String.init(cString:))) : Self.schema.contactName.defaultValue,
      relationship: (indices.idx_relationship >= 0) && (indices.idx_relationship < argc) ? (sqlite3_column_text(statement, indices.idx_relationship).flatMap(String.init(cString:))) : Self.schema.relationship.defaultValue
    )
  }
  
  /**
   * Bind all ``CustomerAndSuppliersByCity`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Customer and Suppliers by City SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = CustomerAndSuppliersByCity(city: "Hello", companyName: "World", contactName: "Duck", relationship: "Donald")
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(city) { ( s ) in
      if indices.idx_city >= 0 {
        sqlite3_bind_text(statement, indices.idx_city, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(companyName) { ( s ) in
        if indices.idx_companyName >= 0 {
          sqlite3_bind_text(statement, indices.idx_companyName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(contactName) { ( s ) in
          if indices.idx_contactName >= 0 {
            sqlite3_bind_text(statement, indices.idx_contactName, s, -1, nil)
          }
          return try NorthwindLighter.withOptCString(relationship) { ( s ) in
            if indices.idx_relationship >= 0 {
              sqlite3_bind_text(statement, indices.idx_relationship, s, -1, nil)
            }
            return try execute()
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.Invoice {
  
  /**
   * Static type information for the ``Invoice`` record (`Invoices` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_shipName: Int32, idx_shipAddress: Int32, idx_shipCity: Int32, idx_shipRegion: Int32, idx_shipPostalCode: Int32, idx_shipCountry: Int32, idx_customerID: Int32, idx_customerName: Int32, idx_address: Int32, idx_city: Int32, idx_region: Int32, idx_postalCode: Int32, idx_country: Int32, idx_salesperson: Int32, idx_orderID: Int32, idx_orderDate: Int32, idx_requiredDate: Int32, idx_shippedDate: Int32, idx_shipperName: Int32, idx_productID: Int32, idx_productName: Int32, idx_unitPrice: Int32, idx_quantity: Int32, idx_discount: Int32, idx_extendedPrice: Int32, idx_freight: Int32 )
    public typealias RecordType = NorthwindLighter.Invoice
    
    /// The SQL table name associated with the ``Invoice`` record.
    public static let externalName = "Invoices"
    
    /// The number of columns the `Invoices` table has.
    public static let columnCount : Int32 = 26
    
    /// SQL to `SELECT` all columns of the `Invoices` table.
    public static let select = #"SELECT "ShipName", "ShipAddress", "ShipCity", "ShipRegion", "ShipPostalCode", "ShipCountry", "CustomerID", "CustomerName", "Address", "City", "Region", "PostalCode", "Country", "Salesperson", "OrderID", "OrderDate", "RequiredDate", "ShippedDate", "ShipperName", "ProductID", "ProductName", "UnitPrice", "Quantity", "Discount", "ExtendedPrice", "Freight" FROM "Invoices""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""ShipName", "ShipAddress", "ShipCity", "ShipRegion", "ShipPostalCode", "ShipCountry", "CustomerID", "CustomerName", "Address", "City", "Region", "PostalCode", "Country", "Salesperson", "OrderID", "OrderDate", "RequiredDate", "ShippedDate", "ShipperName", "ProductID", "ProductName", "UnitPrice", "Quantity", "Discount", "ExtendedPrice", "Freight""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Invoices_id FROM Invoices`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Invoices_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "ShipName") == 0 {
          indices.idx_shipName = i
        }
        else if strcmp(col!, "ShipAddress") == 0 {
          indices.idx_shipAddress = i
        }
        else if strcmp(col!, "ShipCity") == 0 {
          indices.idx_shipCity = i
        }
        else if strcmp(col!, "ShipRegion") == 0 {
          indices.idx_shipRegion = i
        }
        else if strcmp(col!, "ShipPostalCode") == 0 {
          indices.idx_shipPostalCode = i
        }
        else if strcmp(col!, "ShipCountry") == 0 {
          indices.idx_shipCountry = i
        }
        else if strcmp(col!, "CustomerID") == 0 {
          indices.idx_customerID = i
        }
        else if strcmp(col!, "CustomerName") == 0 {
          indices.idx_customerName = i
        }
        else if strcmp(col!, "Address") == 0 {
          indices.idx_address = i
        }
        else if strcmp(col!, "City") == 0 {
          indices.idx_city = i
        }
        else if strcmp(col!, "Region") == 0 {
          indices.idx_region = i
        }
        else if strcmp(col!, "PostalCode") == 0 {
          indices.idx_postalCode = i
        }
        else if strcmp(col!, "Country") == 0 {
          indices.idx_country = i
        }
        else if strcmp(col!, "Salesperson") == 0 {
          indices.idx_salesperson = i
        }
        else if strcmp(col!, "OrderID") == 0 {
          indices.idx_orderID = i
        }
        else if strcmp(col!, "OrderDate") == 0 {
          indices.idx_orderDate = i
        }
        else if strcmp(col!, "RequiredDate") == 0 {
          indices.idx_requiredDate = i
        }
        else if strcmp(col!, "ShippedDate") == 0 {
          indices.idx_shippedDate = i
        }
        else if strcmp(col!, "ShipperName") == 0 {
          indices.idx_shipperName = i
        }
        else if strcmp(col!, "ProductID") == 0 {
          indices.idx_productID = i
        }
        else if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
        else if strcmp(col!, "UnitPrice") == 0 {
          indices.idx_unitPrice = i
        }
        else if strcmp(col!, "Quantity") == 0 {
          indices.idx_quantity = i
        }
        else if strcmp(col!, "Discount") == 0 {
          indices.idx_discount = i
        }
        else if strcmp(col!, "ExtendedPrice") == 0 {
          indices.idx_extendedPrice = i
        }
        else if strcmp(col!, "Freight") == 0 {
          indices.idx_freight = i
        }
      }
      return indices
    }
    
    /// Type information for property ``Invoice/shipName`` (`ShipName` column).
    public let shipName = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ShipName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.shipName
    )
    
    /// Type information for property ``Invoice/shipAddress`` (`ShipAddress` column).
    public let shipAddress = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ShipAddress",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.shipAddress
    )
    
    /// Type information for property ``Invoice/shipCity`` (`ShipCity` column).
    public let shipCity = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ShipCity",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.shipCity
    )
    
    /// Type information for property ``Invoice/shipRegion`` (`ShipRegion` column).
    public let shipRegion = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ShipRegion",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.shipRegion
    )
    
    /// Type information for property ``Invoice/shipPostalCode`` (`ShipPostalCode` column).
    public let shipPostalCode = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ShipPostalCode",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.shipPostalCode
    )
    
    /// Type information for property ``Invoice/shipCountry`` (`ShipCountry` column).
    public let shipCountry = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ShipCountry",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.shipCountry
    )
    
    /// Type information for property ``Invoice/customerID`` (`CustomerID` column).
    public let customerID = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "CustomerID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.customerID
    )
    
    /// Type information for property ``Invoice/customerName`` (`CustomerName` column).
    public let customerName = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "CustomerName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.customerName
    )
    
    /// Type information for property ``Invoice/address`` (`Address` column).
    public let address = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "Address",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.address
    )
    
    /// Type information for property ``Invoice/city`` (`City` column).
    public let city = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "City",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.city
    )
    
    /// Type information for property ``Invoice/region`` (`Region` column).
    public let region = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "Region",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.region
    )
    
    /// Type information for property ``Invoice/postalCode`` (`PostalCode` column).
    public let postalCode = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "PostalCode",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.postalCode
    )
    
    /// Type information for property ``Invoice/country`` (`Country` column).
    public let country = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "Country",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.country
    )
    
    /// Type information for property ``Invoice/salesperson`` (`Salesperson` column).
    public let salesperson = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "Salesperson",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.salesperson
    )
    
    /// Type information for property ``Invoice/orderID`` (`OrderID` column).
    public let orderID = MappedColumn<NorthwindLighter.Invoice, Int?>(
      externalName: "OrderID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.orderID
    )
    
    /// Type information for property ``Invoice/orderDate`` (`OrderDate` column).
    public let orderDate = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "OrderDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.orderDate
    )
    
    /// Type information for property ``Invoice/requiredDate`` (`RequiredDate` column).
    public let requiredDate = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "RequiredDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.requiredDate
    )
    
    /// Type information for property ``Invoice/shippedDate`` (`ShippedDate` column).
    public let shippedDate = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ShippedDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.shippedDate
    )
    
    /// Type information for property ``Invoice/shipperName`` (`ShipperName` column).
    public let shipperName = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ShipperName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.shipperName
    )
    
    /// Type information for property ``Invoice/productID`` (`ProductID` column).
    public let productID = MappedColumn<NorthwindLighter.Invoice, Int?>(
      externalName: "ProductID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.productID
    )
    
    /// Type information for property ``Invoice/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ProductName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.productName
    )
    
    /// Type information for property ``Invoice/unitPrice`` (`UnitPrice` column).
    public let unitPrice = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "UnitPrice",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.unitPrice
    )
    
    /// Type information for property ``Invoice/quantity`` (`Quantity` column).
    public let quantity = MappedColumn<NorthwindLighter.Invoice, Int?>(
      externalName: "Quantity",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.quantity
    )
    
    /// Type information for property ``Invoice/discount`` (`Discount` column).
    public let discount = MappedColumn<NorthwindLighter.Invoice, Double?>(
      externalName: "Discount",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.discount
    )
    
    /// Type information for property ``Invoice/extendedPrice`` (`ExtendedPrice` column).
    public let extendedPrice = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "ExtendedPrice",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.extendedPrice
    )
    
    /// Type information for property ``Invoice/freight`` (`Freight` column).
    public let freight = MappedColumn<NorthwindLighter.Invoice, String?>(
      externalName: "Freight",
      defaultValue: nil,
      keyPath: \NorthwindLighter.Invoice.freight
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ shipName, shipAddress, shipCity, shipRegion, shipPostalCode, shipCountry, customerID, customerName, address, city, region, postalCode, country, salesperson, orderID, orderDate, requiredDate, shippedDate, shipperName, productID, productName, unitPrice, quantity, discount, extendedPrice, freight ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``Invoice`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Invoices", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = Invoice(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      shipName: (indices.idx_shipName >= 0) && (indices.idx_shipName < argc) ? (sqlite3_column_text(statement, indices.idx_shipName).flatMap(String.init(cString:))) : Self.schema.shipName.defaultValue,
      shipAddress: (indices.idx_shipAddress >= 0) && (indices.idx_shipAddress < argc) ? (sqlite3_column_text(statement, indices.idx_shipAddress).flatMap(String.init(cString:))) : Self.schema.shipAddress.defaultValue,
      shipCity: (indices.idx_shipCity >= 0) && (indices.idx_shipCity < argc) ? (sqlite3_column_text(statement, indices.idx_shipCity).flatMap(String.init(cString:))) : Self.schema.shipCity.defaultValue,
      shipRegion: (indices.idx_shipRegion >= 0) && (indices.idx_shipRegion < argc) ? (sqlite3_column_text(statement, indices.idx_shipRegion).flatMap(String.init(cString:))) : Self.schema.shipRegion.defaultValue,
      shipPostalCode: (indices.idx_shipPostalCode >= 0) && (indices.idx_shipPostalCode < argc) ? (sqlite3_column_text(statement, indices.idx_shipPostalCode).flatMap(String.init(cString:))) : Self.schema.shipPostalCode.defaultValue,
      shipCountry: (indices.idx_shipCountry >= 0) && (indices.idx_shipCountry < argc) ? (sqlite3_column_text(statement, indices.idx_shipCountry).flatMap(String.init(cString:))) : Self.schema.shipCountry.defaultValue,
      customerID: (indices.idx_customerID >= 0) && (indices.idx_customerID < argc) ? (sqlite3_column_text(statement, indices.idx_customerID).flatMap(String.init(cString:))) : Self.schema.customerID.defaultValue,
      customerName: (indices.idx_customerName >= 0) && (indices.idx_customerName < argc) ? (sqlite3_column_text(statement, indices.idx_customerName).flatMap(String.init(cString:))) : Self.schema.customerName.defaultValue,
      address: (indices.idx_address >= 0) && (indices.idx_address < argc) ? (sqlite3_column_text(statement, indices.idx_address).flatMap(String.init(cString:))) : Self.schema.address.defaultValue,
      city: (indices.idx_city >= 0) && (indices.idx_city < argc) ? (sqlite3_column_text(statement, indices.idx_city).flatMap(String.init(cString:))) : Self.schema.city.defaultValue,
      region: (indices.idx_region >= 0) && (indices.idx_region < argc) ? (sqlite3_column_text(statement, indices.idx_region).flatMap(String.init(cString:))) : Self.schema.region.defaultValue,
      postalCode: (indices.idx_postalCode >= 0) && (indices.idx_postalCode < argc) ? (sqlite3_column_text(statement, indices.idx_postalCode).flatMap(String.init(cString:))) : Self.schema.postalCode.defaultValue,
      country: (indices.idx_country >= 0) && (indices.idx_country < argc) ? (sqlite3_column_text(statement, indices.idx_country).flatMap(String.init(cString:))) : Self.schema.country.defaultValue,
      salesperson: (indices.idx_salesperson >= 0) && (indices.idx_salesperson < argc) ? (sqlite3_column_text(statement, indices.idx_salesperson).flatMap(String.init(cString:))) : Self.schema.salesperson.defaultValue,
      orderID: (indices.idx_orderID >= 0) && (indices.idx_orderID < argc) ? (sqlite3_column_type(statement, indices.idx_orderID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_orderID)) : nil) : Self.schema.orderID.defaultValue,
      orderDate: (indices.idx_orderDate >= 0) && (indices.idx_orderDate < argc) ? (sqlite3_column_text(statement, indices.idx_orderDate).flatMap(String.init(cString:))) : Self.schema.orderDate.defaultValue,
      requiredDate: (indices.idx_requiredDate >= 0) && (indices.idx_requiredDate < argc) ? (sqlite3_column_text(statement, indices.idx_requiredDate).flatMap(String.init(cString:))) : Self.schema.requiredDate.defaultValue,
      shippedDate: (indices.idx_shippedDate >= 0) && (indices.idx_shippedDate < argc) ? (sqlite3_column_text(statement, indices.idx_shippedDate).flatMap(String.init(cString:))) : Self.schema.shippedDate.defaultValue,
      shipperName: (indices.idx_shipperName >= 0) && (indices.idx_shipperName < argc) ? (sqlite3_column_text(statement, indices.idx_shipperName).flatMap(String.init(cString:))) : Self.schema.shipperName.defaultValue,
      productID: (indices.idx_productID >= 0) && (indices.idx_productID < argc) ? (sqlite3_column_type(statement, indices.idx_productID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_productID)) : nil) : Self.schema.productID.defaultValue,
      productName: (indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : Self.schema.productName.defaultValue,
      unitPrice: (indices.idx_unitPrice >= 0) && (indices.idx_unitPrice < argc) ? (sqlite3_column_text(statement, indices.idx_unitPrice).flatMap(String.init(cString:))) : Self.schema.unitPrice.defaultValue,
      quantity: (indices.idx_quantity >= 0) && (indices.idx_quantity < argc) ? (sqlite3_column_type(statement, indices.idx_quantity) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_quantity)) : nil) : Self.schema.quantity.defaultValue,
      discount: (indices.idx_discount >= 0) && (indices.idx_discount < argc) ? (sqlite3_column_type(statement, indices.idx_discount) != SQLITE_NULL ? sqlite3_column_double(statement, indices.idx_discount) : nil) : Self.schema.discount.defaultValue,
      extendedPrice: (indices.idx_extendedPrice >= 0) && (indices.idx_extendedPrice < argc) ? (sqlite3_column_text(statement, indices.idx_extendedPrice).flatMap(String.init(cString:))) : Self.schema.extendedPrice.defaultValue,
      freight: (indices.idx_freight >= 0) && (indices.idx_freight < argc) ? (sqlite3_column_text(statement, indices.idx_freight).flatMap(String.init(cString:))) : Self.schema.freight.defaultValue
    )
  }
  
  /**
   * Bind all ``Invoice`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Invoices SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = Invoice(shipName: "Hello", shipAddress: "World", shipCity: "Duck", shipRegion: "Donald")
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(shipName) { ( s ) in
      if indices.idx_shipName >= 0 {
        sqlite3_bind_text(statement, indices.idx_shipName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(shipAddress) { ( s ) in
        if indices.idx_shipAddress >= 0 {
          sqlite3_bind_text(statement, indices.idx_shipAddress, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(shipCity) { ( s ) in
          if indices.idx_shipCity >= 0 {
            sqlite3_bind_text(statement, indices.idx_shipCity, s, -1, nil)
          }
          return try NorthwindLighter.withOptCString(shipRegion) { ( s ) in
            if indices.idx_shipRegion >= 0 {
              sqlite3_bind_text(statement, indices.idx_shipRegion, s, -1, nil)
            }
            return try NorthwindLighter.withOptCString(shipPostalCode) { ( s ) in
              if indices.idx_shipPostalCode >= 0 {
                sqlite3_bind_text(statement, indices.idx_shipPostalCode, s, -1, nil)
              }
              return try NorthwindLighter.withOptCString(shipCountry) { ( s ) in
                if indices.idx_shipCountry >= 0 {
                  sqlite3_bind_text(statement, indices.idx_shipCountry, s, -1, nil)
                }
                return try NorthwindLighter.withOptCString(customerID) { ( s ) in
                  if indices.idx_customerID >= 0 {
                    sqlite3_bind_text(statement, indices.idx_customerID, s, -1, nil)
                  }
                  return try NorthwindLighter.withOptCString(customerName) { ( s ) in
                    if indices.idx_customerName >= 0 {
                      sqlite3_bind_text(statement, indices.idx_customerName, s, -1, nil)
                    }
                    return try NorthwindLighter.withOptCString(address) { ( s ) in
                      if indices.idx_address >= 0 {
                        sqlite3_bind_text(statement, indices.idx_address, s, -1, nil)
                      }
                      return try NorthwindLighter.withOptCString(city) { ( s ) in
                        if indices.idx_city >= 0 {
                          sqlite3_bind_text(statement, indices.idx_city, s, -1, nil)
                        }
                        return try NorthwindLighter.withOptCString(region) { ( s ) in
                          if indices.idx_region >= 0 {
                            sqlite3_bind_text(statement, indices.idx_region, s, -1, nil)
                          }
                          return try NorthwindLighter.withOptCString(postalCode) { ( s ) in
                            if indices.idx_postalCode >= 0 {
                              sqlite3_bind_text(statement, indices.idx_postalCode, s, -1, nil)
                            }
                            return try NorthwindLighter.withOptCString(country) { ( s ) in
                              if indices.idx_country >= 0 {
                                sqlite3_bind_text(statement, indices.idx_country, s, -1, nil)
                              }
                              return try NorthwindLighter.withOptCString(salesperson) { ( s ) in
                                if indices.idx_salesperson >= 0 {
                                  sqlite3_bind_text(statement, indices.idx_salesperson, s, -1, nil)
                                }
                                if indices.idx_orderID >= 0 {
                                  if let orderID = orderID {
                                    sqlite3_bind_int64(statement, indices.idx_orderID, Int64(orderID))
                                  }
                                  else {
                                    sqlite3_bind_null(statement, indices.idx_orderID)
                                  }
                                }
                                return try NorthwindLighter.withOptCString(orderDate) { ( s ) in
                                  if indices.idx_orderDate >= 0 {
                                    sqlite3_bind_text(statement, indices.idx_orderDate, s, -1, nil)
                                  }
                                  return try NorthwindLighter.withOptCString(requiredDate) { ( s ) in
                                    if indices.idx_requiredDate >= 0 {
                                      sqlite3_bind_text(statement, indices.idx_requiredDate, s, -1, nil)
                                    }
                                    return try NorthwindLighter.withOptCString(shippedDate) { ( s ) in
                                      if indices.idx_shippedDate >= 0 {
                                        sqlite3_bind_text(statement, indices.idx_shippedDate, s, -1, nil)
                                      }
                                      return try NorthwindLighter.withOptCString(shipperName) { ( s ) in
                                        if indices.idx_shipperName >= 0 {
                                          sqlite3_bind_text(statement, indices.idx_shipperName, s, -1, nil)
                                        }
                                        if indices.idx_productID >= 0 {
                                          if let productID = productID {
                                            sqlite3_bind_int64(statement, indices.idx_productID, Int64(productID))
                                          }
                                          else {
                                            sqlite3_bind_null(statement, indices.idx_productID)
                                          }
                                        }
                                        return try NorthwindLighter.withOptCString(productName) { ( s ) in
                                          if indices.idx_productName >= 0 {
                                            sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
                                          }
                                          return try NorthwindLighter.withOptCString(unitPrice) { ( s ) in
                                            if indices.idx_unitPrice >= 0 {
                                              sqlite3_bind_text(statement, indices.idx_unitPrice, s, -1, nil)
                                            }
                                            if indices.idx_quantity >= 0 {
                                              if let quantity = quantity {
                                                sqlite3_bind_int64(statement, indices.idx_quantity, Int64(quantity))
                                              }
                                              else {
                                                sqlite3_bind_null(statement, indices.idx_quantity)
                                              }
                                            }
                                            if indices.idx_discount >= 0 {
                                              if let discount = discount {
                                                sqlite3_bind_double(statement, indices.idx_discount, discount)
                                              }
                                              else {
                                                sqlite3_bind_null(statement, indices.idx_discount)
                                              }
                                            }
                                            return try NorthwindLighter.withOptCString(extendedPrice) { ( s ) in
                                              if indices.idx_extendedPrice >= 0 {
                                                sqlite3_bind_text(statement, indices.idx_extendedPrice, s, -1, nil)
                                              }
                                              return try NorthwindLighter.withOptCString(freight) { ( s ) in
                                                if indices.idx_freight >= 0 {
                                                  sqlite3_bind_text(statement, indices.idx_freight, s, -1, nil)
                                                }
                                                return try execute()
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.OrdersQry {
  
  /**
   * Static type information for the ``OrdersQry`` record (`Orders Qry` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_orderID: Int32, idx_customerID: Int32, idx_employeeID: Int32, idx_orderDate: Int32, idx_requiredDate: Int32, idx_shippedDate: Int32, idx_shipVia: Int32, idx_freight: Int32, idx_shipName: Int32, idx_shipAddress: Int32, idx_shipCity: Int32, idx_shipRegion: Int32, idx_shipPostalCode: Int32, idx_shipCountry: Int32, idx_companyName: Int32, idx_address: Int32, idx_city: Int32, idx_region: Int32, idx_postalCode: Int32, idx_country: Int32 )
    public typealias RecordType = NorthwindLighter.OrdersQry
    
    /// The SQL table name associated with the ``OrdersQry`` record.
    public static let externalName = "Orders Qry"
    
    /// The number of columns the `Orders Qry` table has.
    public static let columnCount : Int32 = 20
    
    /// SQL to `SELECT` all columns of the `Orders Qry` table.
    public static let select = #"SELECT "OrderID", "CustomerID", "EmployeeID", "OrderDate", "RequiredDate", "ShippedDate", "ShipVia", "Freight", "ShipName", "ShipAddress", "ShipCity", "ShipRegion", "ShipPostalCode", "ShipCountry", "CompanyName", "Address", "City", "Region", "PostalCode", "Country" FROM "Orders Qry""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""OrderID", "CustomerID", "EmployeeID", "OrderDate", "RequiredDate", "ShippedDate", "ShipVia", "Freight", "ShipName", "ShipAddress", "ShipCity", "ShipRegion", "ShipPostalCode", "ShipCountry", "CompanyName", "Address", "City", "Region", "PostalCode", "Country""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Orders Qry_id FROM Orders Qry`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Orders Qry_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "OrderID") == 0 {
          indices.idx_orderID = i
        }
        else if strcmp(col!, "CustomerID") == 0 {
          indices.idx_customerID = i
        }
        else if strcmp(col!, "EmployeeID") == 0 {
          indices.idx_employeeID = i
        }
        else if strcmp(col!, "OrderDate") == 0 {
          indices.idx_orderDate = i
        }
        else if strcmp(col!, "RequiredDate") == 0 {
          indices.idx_requiredDate = i
        }
        else if strcmp(col!, "ShippedDate") == 0 {
          indices.idx_shippedDate = i
        }
        else if strcmp(col!, "ShipVia") == 0 {
          indices.idx_shipVia = i
        }
        else if strcmp(col!, "Freight") == 0 {
          indices.idx_freight = i
        }
        else if strcmp(col!, "ShipName") == 0 {
          indices.idx_shipName = i
        }
        else if strcmp(col!, "ShipAddress") == 0 {
          indices.idx_shipAddress = i
        }
        else if strcmp(col!, "ShipCity") == 0 {
          indices.idx_shipCity = i
        }
        else if strcmp(col!, "ShipRegion") == 0 {
          indices.idx_shipRegion = i
        }
        else if strcmp(col!, "ShipPostalCode") == 0 {
          indices.idx_shipPostalCode = i
        }
        else if strcmp(col!, "ShipCountry") == 0 {
          indices.idx_shipCountry = i
        }
        else if strcmp(col!, "CompanyName") == 0 {
          indices.idx_companyName = i
        }
        else if strcmp(col!, "Address") == 0 {
          indices.idx_address = i
        }
        else if strcmp(col!, "City") == 0 {
          indices.idx_city = i
        }
        else if strcmp(col!, "Region") == 0 {
          indices.idx_region = i
        }
        else if strcmp(col!, "PostalCode") == 0 {
          indices.idx_postalCode = i
        }
        else if strcmp(col!, "Country") == 0 {
          indices.idx_country = i
        }
      }
      return indices
    }
    
    /// Type information for property ``OrdersQry/orderID`` (`OrderID` column).
    public let orderID = MappedColumn<NorthwindLighter.OrdersQry, Int?>(
      externalName: "OrderID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.orderID
    )
    
    /// Type information for property ``OrdersQry/customerID`` (`CustomerID` column).
    public let customerID = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "CustomerID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.customerID
    )
    
    /// Type information for property ``OrdersQry/employeeID`` (`EmployeeID` column).
    public let employeeID = MappedColumn<NorthwindLighter.OrdersQry, Int?>(
      externalName: "EmployeeID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.employeeID
    )
    
    /// Type information for property ``OrdersQry/orderDate`` (`OrderDate` column).
    public let orderDate = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "OrderDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.orderDate
    )
    
    /// Type information for property ``OrdersQry/requiredDate`` (`RequiredDate` column).
    public let requiredDate = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "RequiredDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.requiredDate
    )
    
    /// Type information for property ``OrdersQry/shippedDate`` (`ShippedDate` column).
    public let shippedDate = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "ShippedDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.shippedDate
    )
    
    /// Type information for property ``OrdersQry/shipVia`` (`ShipVia` column).
    public let shipVia = MappedColumn<NorthwindLighter.OrdersQry, Int?>(
      externalName: "ShipVia",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.shipVia
    )
    
    /// Type information for property ``OrdersQry/freight`` (`Freight` column).
    public let freight = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "Freight",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.freight
    )
    
    /// Type information for property ``OrdersQry/shipName`` (`ShipName` column).
    public let shipName = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "ShipName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.shipName
    )
    
    /// Type information for property ``OrdersQry/shipAddress`` (`ShipAddress` column).
    public let shipAddress = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "ShipAddress",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.shipAddress
    )
    
    /// Type information for property ``OrdersQry/shipCity`` (`ShipCity` column).
    public let shipCity = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "ShipCity",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.shipCity
    )
    
    /// Type information for property ``OrdersQry/shipRegion`` (`ShipRegion` column).
    public let shipRegion = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "ShipRegion",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.shipRegion
    )
    
    /// Type information for property ``OrdersQry/shipPostalCode`` (`ShipPostalCode` column).
    public let shipPostalCode = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "ShipPostalCode",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.shipPostalCode
    )
    
    /// Type information for property ``OrdersQry/shipCountry`` (`ShipCountry` column).
    public let shipCountry = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "ShipCountry",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.shipCountry
    )
    
    /// Type information for property ``OrdersQry/companyName`` (`CompanyName` column).
    public let companyName = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "CompanyName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.companyName
    )
    
    /// Type information for property ``OrdersQry/address`` (`Address` column).
    public let address = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "Address",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.address
    )
    
    /// Type information for property ``OrdersQry/city`` (`City` column).
    public let city = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "City",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.city
    )
    
    /// Type information for property ``OrdersQry/region`` (`Region` column).
    public let region = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "Region",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.region
    )
    
    /// Type information for property ``OrdersQry/postalCode`` (`PostalCode` column).
    public let postalCode = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "PostalCode",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.postalCode
    )
    
    /// Type information for property ``OrdersQry/country`` (`Country` column).
    public let country = MappedColumn<NorthwindLighter.OrdersQry, String?>(
      externalName: "Country",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrdersQry.country
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ orderID, customerID, employeeID, orderDate, requiredDate, shippedDate, shipVia, freight, shipName, shipAddress, shipCity, shipRegion, shipPostalCode, shipCountry, companyName, address, city, region, postalCode, country ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``OrdersQry`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Orders Qry", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = OrdersQry(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      orderID: (indices.idx_orderID >= 0) && (indices.idx_orderID < argc) ? (sqlite3_column_type(statement, indices.idx_orderID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_orderID)) : nil) : Self.schema.orderID.defaultValue,
      customerID: (indices.idx_customerID >= 0) && (indices.idx_customerID < argc) ? (sqlite3_column_text(statement, indices.idx_customerID).flatMap(String.init(cString:))) : Self.schema.customerID.defaultValue,
      employeeID: (indices.idx_employeeID >= 0) && (indices.idx_employeeID < argc) ? (sqlite3_column_type(statement, indices.idx_employeeID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_employeeID)) : nil) : Self.schema.employeeID.defaultValue,
      orderDate: (indices.idx_orderDate >= 0) && (indices.idx_orderDate < argc) ? (sqlite3_column_text(statement, indices.idx_orderDate).flatMap(String.init(cString:))) : Self.schema.orderDate.defaultValue,
      requiredDate: (indices.idx_requiredDate >= 0) && (indices.idx_requiredDate < argc) ? (sqlite3_column_text(statement, indices.idx_requiredDate).flatMap(String.init(cString:))) : Self.schema.requiredDate.defaultValue,
      shippedDate: (indices.idx_shippedDate >= 0) && (indices.idx_shippedDate < argc) ? (sqlite3_column_text(statement, indices.idx_shippedDate).flatMap(String.init(cString:))) : Self.schema.shippedDate.defaultValue,
      shipVia: (indices.idx_shipVia >= 0) && (indices.idx_shipVia < argc) ? (sqlite3_column_type(statement, indices.idx_shipVia) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_shipVia)) : nil) : Self.schema.shipVia.defaultValue,
      freight: (indices.idx_freight >= 0) && (indices.idx_freight < argc) ? (sqlite3_column_text(statement, indices.idx_freight).flatMap(String.init(cString:))) : Self.schema.freight.defaultValue,
      shipName: (indices.idx_shipName >= 0) && (indices.idx_shipName < argc) ? (sqlite3_column_text(statement, indices.idx_shipName).flatMap(String.init(cString:))) : Self.schema.shipName.defaultValue,
      shipAddress: (indices.idx_shipAddress >= 0) && (indices.idx_shipAddress < argc) ? (sqlite3_column_text(statement, indices.idx_shipAddress).flatMap(String.init(cString:))) : Self.schema.shipAddress.defaultValue,
      shipCity: (indices.idx_shipCity >= 0) && (indices.idx_shipCity < argc) ? (sqlite3_column_text(statement, indices.idx_shipCity).flatMap(String.init(cString:))) : Self.schema.shipCity.defaultValue,
      shipRegion: (indices.idx_shipRegion >= 0) && (indices.idx_shipRegion < argc) ? (sqlite3_column_text(statement, indices.idx_shipRegion).flatMap(String.init(cString:))) : Self.schema.shipRegion.defaultValue,
      shipPostalCode: (indices.idx_shipPostalCode >= 0) && (indices.idx_shipPostalCode < argc) ? (sqlite3_column_text(statement, indices.idx_shipPostalCode).flatMap(String.init(cString:))) : Self.schema.shipPostalCode.defaultValue,
      shipCountry: (indices.idx_shipCountry >= 0) && (indices.idx_shipCountry < argc) ? (sqlite3_column_text(statement, indices.idx_shipCountry).flatMap(String.init(cString:))) : Self.schema.shipCountry.defaultValue,
      companyName: (indices.idx_companyName >= 0) && (indices.idx_companyName < argc) ? (sqlite3_column_text(statement, indices.idx_companyName).flatMap(String.init(cString:))) : Self.schema.companyName.defaultValue,
      address: (indices.idx_address >= 0) && (indices.idx_address < argc) ? (sqlite3_column_text(statement, indices.idx_address).flatMap(String.init(cString:))) : Self.schema.address.defaultValue,
      city: (indices.idx_city >= 0) && (indices.idx_city < argc) ? (sqlite3_column_text(statement, indices.idx_city).flatMap(String.init(cString:))) : Self.schema.city.defaultValue,
      region: (indices.idx_region >= 0) && (indices.idx_region < argc) ? (sqlite3_column_text(statement, indices.idx_region).flatMap(String.init(cString:))) : Self.schema.region.defaultValue,
      postalCode: (indices.idx_postalCode >= 0) && (indices.idx_postalCode < argc) ? (sqlite3_column_text(statement, indices.idx_postalCode).flatMap(String.init(cString:))) : Self.schema.postalCode.defaultValue,
      country: (indices.idx_country >= 0) && (indices.idx_country < argc) ? (sqlite3_column_text(statement, indices.idx_country).flatMap(String.init(cString:))) : Self.schema.country.defaultValue
    )
  }
  
  /**
   * Bind all ``OrdersQry`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Orders Qry SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = OrdersQry(orderID: 1, customerID: "Hello", employeeID: 2, orderDate: nil)
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_orderID >= 0 {
      if let orderID = orderID {
        sqlite3_bind_int64(statement, indices.idx_orderID, Int64(orderID))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_orderID)
      }
    }
    return try NorthwindLighter.withOptCString(customerID) { ( s ) in
      if indices.idx_customerID >= 0 {
        sqlite3_bind_text(statement, indices.idx_customerID, s, -1, nil)
      }
      if indices.idx_employeeID >= 0 {
        if let employeeID = employeeID {
          sqlite3_bind_int64(statement, indices.idx_employeeID, Int64(employeeID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_employeeID)
        }
      }
      return try NorthwindLighter.withOptCString(orderDate) { ( s ) in
        if indices.idx_orderDate >= 0 {
          sqlite3_bind_text(statement, indices.idx_orderDate, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(requiredDate) { ( s ) in
          if indices.idx_requiredDate >= 0 {
            sqlite3_bind_text(statement, indices.idx_requiredDate, s, -1, nil)
          }
          return try NorthwindLighter.withOptCString(shippedDate) { ( s ) in
            if indices.idx_shippedDate >= 0 {
              sqlite3_bind_text(statement, indices.idx_shippedDate, s, -1, nil)
            }
            if indices.idx_shipVia >= 0 {
              if let shipVia = shipVia {
                sqlite3_bind_int64(statement, indices.idx_shipVia, Int64(shipVia))
              }
              else {
                sqlite3_bind_null(statement, indices.idx_shipVia)
              }
            }
            return try NorthwindLighter.withOptCString(freight) { ( s ) in
              if indices.idx_freight >= 0 {
                sqlite3_bind_text(statement, indices.idx_freight, s, -1, nil)
              }
              return try NorthwindLighter.withOptCString(shipName) { ( s ) in
                if indices.idx_shipName >= 0 {
                  sqlite3_bind_text(statement, indices.idx_shipName, s, -1, nil)
                }
                return try NorthwindLighter.withOptCString(shipAddress) { ( s ) in
                  if indices.idx_shipAddress >= 0 {
                    sqlite3_bind_text(statement, indices.idx_shipAddress, s, -1, nil)
                  }
                  return try NorthwindLighter.withOptCString(shipCity) { ( s ) in
                    if indices.idx_shipCity >= 0 {
                      sqlite3_bind_text(statement, indices.idx_shipCity, s, -1, nil)
                    }
                    return try NorthwindLighter.withOptCString(shipRegion) { ( s ) in
                      if indices.idx_shipRegion >= 0 {
                        sqlite3_bind_text(statement, indices.idx_shipRegion, s, -1, nil)
                      }
                      return try NorthwindLighter.withOptCString(shipPostalCode) { ( s ) in
                        if indices.idx_shipPostalCode >= 0 {
                          sqlite3_bind_text(statement, indices.idx_shipPostalCode, s, -1, nil)
                        }
                        return try NorthwindLighter.withOptCString(shipCountry) { ( s ) in
                          if indices.idx_shipCountry >= 0 {
                            sqlite3_bind_text(statement, indices.idx_shipCountry, s, -1, nil)
                          }
                          return try NorthwindLighter.withOptCString(companyName) { ( s ) in
                            if indices.idx_companyName >= 0 {
                              sqlite3_bind_text(statement, indices.idx_companyName, s, -1, nil)
                            }
                            return try NorthwindLighter.withOptCString(address) { ( s ) in
                              if indices.idx_address >= 0 {
                                sqlite3_bind_text(statement, indices.idx_address, s, -1, nil)
                              }
                              return try NorthwindLighter.withOptCString(city) { ( s ) in
                                if indices.idx_city >= 0 {
                                  sqlite3_bind_text(statement, indices.idx_city, s, -1, nil)
                                }
                                return try NorthwindLighter.withOptCString(region) { ( s ) in
                                  if indices.idx_region >= 0 {
                                    sqlite3_bind_text(statement, indices.idx_region, s, -1, nil)
                                  }
                                  return try NorthwindLighter.withOptCString(postalCode) { ( s ) in
                                    if indices.idx_postalCode >= 0 {
                                      sqlite3_bind_text(statement, indices.idx_postalCode, s, -1, nil)
                                    }
                                    return try NorthwindLighter.withOptCString(country) { ( s ) in
                                      if indices.idx_country >= 0 {
                                        sqlite3_bind_text(statement, indices.idx_country, s, -1, nil)
                                      }
                                      return try execute()
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.OrderSubtotal {
  
  /**
   * Static type information for the ``OrderSubtotal`` record (`Order Subtotals` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_orderID: Int32, idx_subtotal: Int32 )
    public typealias RecordType = NorthwindLighter.OrderSubtotal
    
    /// The SQL table name associated with the ``OrderSubtotal`` record.
    public static let externalName = "Order Subtotals"
    
    /// The number of columns the `Order Subtotals` table has.
    public static let columnCount : Int32 = 2
    
    /// SQL to `SELECT` all columns of the `Order Subtotals` table.
    public static let select = #"SELECT "OrderID", "Subtotal" FROM "Order Subtotals""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""OrderID", "Subtotal""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Order Subtotals_id FROM Order Subtotals`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Order Subtotals_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "OrderID") == 0 {
          indices.idx_orderID = i
        }
        else if strcmp(col!, "Subtotal") == 0 {
          indices.idx_subtotal = i
        }
      }
      return indices
    }
    
    /// Type information for property ``OrderSubtotal/orderID`` (`OrderID` column).
    public let orderID = MappedColumn<NorthwindLighter.OrderSubtotal, Int?>(
      externalName: "OrderID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderSubtotal.orderID
    )
    
    /// Type information for property ``OrderSubtotal/subtotal`` (`Subtotal` column).
    public let subtotal = MappedColumn<NorthwindLighter.OrderSubtotal, String?>(
      externalName: "Subtotal",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderSubtotal.subtotal
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ orderID, subtotal ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``OrderSubtotal`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Order Subtotals", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = OrderSubtotal(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      orderID: (indices.idx_orderID >= 0) && (indices.idx_orderID < argc) ? (sqlite3_column_type(statement, indices.idx_orderID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_orderID)) : nil) : Self.schema.orderID.defaultValue,
      subtotal: (indices.idx_subtotal >= 0) && (indices.idx_subtotal < argc) ? (sqlite3_column_text(statement, indices.idx_subtotal).flatMap(String.init(cString:))) : Self.schema.subtotal.defaultValue
    )
  }
  
  /**
   * Bind all ``OrderSubtotal`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Order Subtotals SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = OrderSubtotal(orderID: 1, subtotal: "Hello")
   * let ok = record.bind(to: statement, indices: ( 1, 2 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_orderID >= 0 {
      if let orderID = orderID {
        sqlite3_bind_int64(statement, indices.idx_orderID, Int64(orderID))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_orderID)
      }
    }
    return try NorthwindLighter.withOptCString(subtotal) { ( s ) in
      if indices.idx_subtotal >= 0 {
        sqlite3_bind_text(statement, indices.idx_subtotal, s, -1, nil)
      }
      return try execute()
    }
  }
}

public extension NorthwindLighter.ProductSalesFor1997 {
  
  /**
   * Static type information for the ``ProductSalesFor1997`` record (`Product Sales for 1997` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_categoryName: Int32, idx_productName: Int32, idx_productSales: Int32 )
    public typealias RecordType = NorthwindLighter.ProductSalesFor1997
    
    /// The SQL table name associated with the ``ProductSalesFor1997`` record.
    public static let externalName = "Product Sales for 1997"
    
    /// The number of columns the `Product Sales for 1997` table has.
    public static let columnCount : Int32 = 3
    
    /// SQL to `SELECT` all columns of the `Product Sales for 1997` table.
    public static let select = #"SELECT "CategoryName", "ProductName", "ProductSales" FROM "Product Sales for 1997""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CategoryName", "ProductName", "ProductSales""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Product Sales for 1997_id FROM Product Sales for 1997`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Product Sales for 1997_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CategoryName") == 0 {
          indices.idx_categoryName = i
        }
        else if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
        else if strcmp(col!, "ProductSales") == 0 {
          indices.idx_productSales = i
        }
      }
      return indices
    }
    
    /// Type information for property ``ProductSalesFor1997/categoryName`` (`CategoryName` column).
    public let categoryName = MappedColumn<NorthwindLighter.ProductSalesFor1997, String?>(
      externalName: "CategoryName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductSalesFor1997.categoryName
    )
    
    /// Type information for property ``ProductSalesFor1997/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.ProductSalesFor1997, String?>(
      externalName: "ProductName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductSalesFor1997.productName
    )
    
    /// Type information for property ``ProductSalesFor1997/productSales`` (`ProductSales` column).
    public let productSales = MappedColumn<NorthwindLighter.ProductSalesFor1997, String?>(
      externalName: "ProductSales",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductSalesFor1997.productSales
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ categoryName, productName, productSales ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``ProductSalesFor1997`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Product Sales for 1997", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = ProductSalesFor1997(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      categoryName: (indices.idx_categoryName >= 0) && (indices.idx_categoryName < argc) ? (sqlite3_column_text(statement, indices.idx_categoryName).flatMap(String.init(cString:))) : Self.schema.categoryName.defaultValue,
      productName: (indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : Self.schema.productName.defaultValue,
      productSales: (indices.idx_productSales >= 0) && (indices.idx_productSales < argc) ? (sqlite3_column_text(statement, indices.idx_productSales).flatMap(String.init(cString:))) : Self.schema.productSales.defaultValue
    )
  }
  
  /**
   * Bind all ``ProductSalesFor1997`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Product Sales for 1997 SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = ProductSalesFor1997(categoryName: "Hello", productName: "World", productSales: "Duck")
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(categoryName) { ( s ) in
      if indices.idx_categoryName >= 0 {
        sqlite3_bind_text(statement, indices.idx_categoryName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(productName) { ( s ) in
        if indices.idx_productName >= 0 {
          sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(productSales) { ( s ) in
          if indices.idx_productSales >= 0 {
            sqlite3_bind_text(statement, indices.idx_productSales, s, -1, nil)
          }
          return try execute()
        }
      }
    }
  }
}

public extension NorthwindLighter.ProductsAboveAveragePrice {
  
  /**
   * Static type information for the ``ProductsAboveAveragePrice`` record (`Products Above Average Price` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_productName: Int32, idx_unitPrice: Int32 )
    public typealias RecordType = NorthwindLighter.ProductsAboveAveragePrice
    
    /// The SQL table name associated with the ``ProductsAboveAveragePrice`` record.
    public static let externalName = "Products Above Average Price"
    
    /// The number of columns the `Products Above Average Price` table has.
    public static let columnCount : Int32 = 2
    
    /// SQL to `SELECT` all columns of the `Products Above Average Price` table.
    public static let select = #"SELECT "ProductName", "UnitPrice" FROM "Products Above Average Price""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""ProductName", "UnitPrice""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Products Above Average Price_id FROM Products Above Average Price`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Products Above Average Price_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
        else if strcmp(col!, "UnitPrice") == 0 {
          indices.idx_unitPrice = i
        }
      }
      return indices
    }
    
    /// Type information for property ``ProductsAboveAveragePrice/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.ProductsAboveAveragePrice, String?>(
      externalName: "ProductName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductsAboveAveragePrice.productName
    )
    
    /// Type information for property ``ProductsAboveAveragePrice/unitPrice`` (`UnitPrice` column).
    public let unitPrice = MappedColumn<NorthwindLighter.ProductsAboveAveragePrice, String?>(
      externalName: "UnitPrice",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductsAboveAveragePrice.unitPrice
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ productName, unitPrice ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``ProductsAboveAveragePrice`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Products Above Average Price", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = ProductsAboveAveragePrice(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      productName: (indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : Self.schema.productName.defaultValue,
      unitPrice: (indices.idx_unitPrice >= 0) && (indices.idx_unitPrice < argc) ? (sqlite3_column_text(statement, indices.idx_unitPrice).flatMap(String.init(cString:))) : Self.schema.unitPrice.defaultValue
    )
  }
  
  /**
   * Bind all ``ProductsAboveAveragePrice`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Products Above Average Price SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = ProductsAboveAveragePrice(productName: "Hello", unitPrice: "World")
   * let ok = record.bind(to: statement, indices: ( 1, 2 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(productName) { ( s ) in
      if indices.idx_productName >= 0 {
        sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(unitPrice) { ( s ) in
        if indices.idx_unitPrice >= 0 {
          sqlite3_bind_text(statement, indices.idx_unitPrice, s, -1, nil)
        }
        return try execute()
      }
    }
  }
}

public extension NorthwindLighter.ProductsByCategory {
  
  /**
   * Static type information for the ``ProductsByCategory`` record (`Products by Category` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_categoryName: Int32, idx_productName: Int32, idx_quantityPerUnit: Int32, idx_unitsInStock: Int32, idx_discontinued: Int32 )
    public typealias RecordType = NorthwindLighter.ProductsByCategory
    
    /// The SQL table name associated with the ``ProductsByCategory`` record.
    public static let externalName = "Products by Category"
    
    /// The number of columns the `Products by Category` table has.
    public static let columnCount : Int32 = 5
    
    /// SQL to `SELECT` all columns of the `Products by Category` table.
    public static let select = #"SELECT "CategoryName", "ProductName", "QuantityPerUnit", "UnitsInStock", "Discontinued" FROM "Products by Category""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CategoryName", "ProductName", "QuantityPerUnit", "UnitsInStock", "Discontinued""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Products by Category_id FROM Products by Category`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Products by Category_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CategoryName") == 0 {
          indices.idx_categoryName = i
        }
        else if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
        else if strcmp(col!, "QuantityPerUnit") == 0 {
          indices.idx_quantityPerUnit = i
        }
        else if strcmp(col!, "UnitsInStock") == 0 {
          indices.idx_unitsInStock = i
        }
        else if strcmp(col!, "Discontinued") == 0 {
          indices.idx_discontinued = i
        }
      }
      return indices
    }
    
    /// Type information for property ``ProductsByCategory/categoryName`` (`CategoryName` column).
    public let categoryName = MappedColumn<NorthwindLighter.ProductsByCategory, String?>(
      externalName: "CategoryName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductsByCategory.categoryName
    )
    
    /// Type information for property ``ProductsByCategory/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.ProductsByCategory, String?>(
      externalName: "ProductName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductsByCategory.productName
    )
    
    /// Type information for property ``ProductsByCategory/quantityPerUnit`` (`QuantityPerUnit` column).
    public let quantityPerUnit = MappedColumn<NorthwindLighter.ProductsByCategory, String?>(
      externalName: "QuantityPerUnit",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductsByCategory.quantityPerUnit
    )
    
    /// Type information for property ``ProductsByCategory/unitsInStock`` (`UnitsInStock` column).
    public let unitsInStock = MappedColumn<NorthwindLighter.ProductsByCategory, Int?>(
      externalName: "UnitsInStock",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductsByCategory.unitsInStock
    )
    
    /// Type information for property ``ProductsByCategory/discontinued`` (`Discontinued` column).
    public let discontinued = MappedColumn<NorthwindLighter.ProductsByCategory, String?>(
      externalName: "Discontinued",
      defaultValue: nil,
      keyPath: \NorthwindLighter.ProductsByCategory.discontinued
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ categoryName, productName, quantityPerUnit, unitsInStock, discontinued ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``ProductsByCategory`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Products by Category", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = ProductsByCategory(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      categoryName: (indices.idx_categoryName >= 0) && (indices.idx_categoryName < argc) ? (sqlite3_column_text(statement, indices.idx_categoryName).flatMap(String.init(cString:))) : Self.schema.categoryName.defaultValue,
      productName: (indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : Self.schema.productName.defaultValue,
      quantityPerUnit: (indices.idx_quantityPerUnit >= 0) && (indices.idx_quantityPerUnit < argc) ? (sqlite3_column_text(statement, indices.idx_quantityPerUnit).flatMap(String.init(cString:))) : Self.schema.quantityPerUnit.defaultValue,
      unitsInStock: (indices.idx_unitsInStock >= 0) && (indices.idx_unitsInStock < argc) ? (sqlite3_column_type(statement, indices.idx_unitsInStock) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_unitsInStock)) : nil) : Self.schema.unitsInStock.defaultValue,
      discontinued: (indices.idx_discontinued >= 0) && (indices.idx_discontinued < argc) ? (sqlite3_column_text(statement, indices.idx_discontinued).flatMap(String.init(cString:))) : Self.schema.discontinued.defaultValue
    )
  }
  
  /**
   * Bind all ``ProductsByCategory`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Products by Category SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = ProductsByCategory(categoryName: "Hello", productName: "World", quantityPerUnit: "Duck", unitsInStock: 1)
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4, 5 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(categoryName) { ( s ) in
      if indices.idx_categoryName >= 0 {
        sqlite3_bind_text(statement, indices.idx_categoryName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(productName) { ( s ) in
        if indices.idx_productName >= 0 {
          sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(quantityPerUnit) { ( s ) in
          if indices.idx_quantityPerUnit >= 0 {
            sqlite3_bind_text(statement, indices.idx_quantityPerUnit, s, -1, nil)
          }
          if indices.idx_unitsInStock >= 0 {
            if let unitsInStock = unitsInStock {
              sqlite3_bind_int64(statement, indices.idx_unitsInStock, Int64(unitsInStock))
            }
            else {
              sqlite3_bind_null(statement, indices.idx_unitsInStock)
            }
          }
          return try NorthwindLighter.withOptCString(discontinued) { ( s ) in
            if indices.idx_discontinued >= 0 {
              sqlite3_bind_text(statement, indices.idx_discontinued, s, -1, nil)
            }
            return try execute()
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.QuarterlyOrder {
  
  /**
   * Static type information for the ``QuarterlyOrder`` record (`Quarterly Orders` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_customerID: Int32, idx_companyName: Int32, idx_city: Int32, idx_country: Int32 )
    public typealias RecordType = NorthwindLighter.QuarterlyOrder
    
    /// The SQL table name associated with the ``QuarterlyOrder`` record.
    public static let externalName = "Quarterly Orders"
    
    /// The number of columns the `Quarterly Orders` table has.
    public static let columnCount : Int32 = 4
    
    /// SQL to `SELECT` all columns of the `Quarterly Orders` table.
    public static let select = #"SELECT "CustomerID", "CompanyName", "City", "Country" FROM "Quarterly Orders""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CustomerID", "CompanyName", "City", "Country""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Quarterly Orders_id FROM Quarterly Orders`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Quarterly Orders_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CustomerID") == 0 {
          indices.idx_customerID = i
        }
        else if strcmp(col!, "CompanyName") == 0 {
          indices.idx_companyName = i
        }
        else if strcmp(col!, "City") == 0 {
          indices.idx_city = i
        }
        else if strcmp(col!, "Country") == 0 {
          indices.idx_country = i
        }
      }
      return indices
    }
    
    /// Type information for property ``QuarterlyOrder/customerID`` (`CustomerID` column).
    public let customerID = MappedColumn<NorthwindLighter.QuarterlyOrder, String?>(
      externalName: "CustomerID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.QuarterlyOrder.customerID
    )
    
    /// Type information for property ``QuarterlyOrder/companyName`` (`CompanyName` column).
    public let companyName = MappedColumn<NorthwindLighter.QuarterlyOrder, String?>(
      externalName: "CompanyName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.QuarterlyOrder.companyName
    )
    
    /// Type information for property ``QuarterlyOrder/city`` (`City` column).
    public let city = MappedColumn<NorthwindLighter.QuarterlyOrder, String?>(
      externalName: "City",
      defaultValue: nil,
      keyPath: \NorthwindLighter.QuarterlyOrder.city
    )
    
    /// Type information for property ``QuarterlyOrder/country`` (`Country` column).
    public let country = MappedColumn<NorthwindLighter.QuarterlyOrder, String?>(
      externalName: "Country",
      defaultValue: nil,
      keyPath: \NorthwindLighter.QuarterlyOrder.country
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ customerID, companyName, city, country ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``QuarterlyOrder`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Quarterly Orders", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = QuarterlyOrder(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      customerID: (indices.idx_customerID >= 0) && (indices.idx_customerID < argc) ? (sqlite3_column_text(statement, indices.idx_customerID).flatMap(String.init(cString:))) : Self.schema.customerID.defaultValue,
      companyName: (indices.idx_companyName >= 0) && (indices.idx_companyName < argc) ? (sqlite3_column_text(statement, indices.idx_companyName).flatMap(String.init(cString:))) : Self.schema.companyName.defaultValue,
      city: (indices.idx_city >= 0) && (indices.idx_city < argc) ? (sqlite3_column_text(statement, indices.idx_city).flatMap(String.init(cString:))) : Self.schema.city.defaultValue,
      country: (indices.idx_country >= 0) && (indices.idx_country < argc) ? (sqlite3_column_text(statement, indices.idx_country).flatMap(String.init(cString:))) : Self.schema.country.defaultValue
    )
  }
  
  /**
   * Bind all ``QuarterlyOrder`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Quarterly Orders SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = QuarterlyOrder(customerID: "Hello", companyName: "World", city: "Duck", country: "Donald")
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(customerID) { ( s ) in
      if indices.idx_customerID >= 0 {
        sqlite3_bind_text(statement, indices.idx_customerID, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(companyName) { ( s ) in
        if indices.idx_companyName >= 0 {
          sqlite3_bind_text(statement, indices.idx_companyName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(city) { ( s ) in
          if indices.idx_city >= 0 {
            sqlite3_bind_text(statement, indices.idx_city, s, -1, nil)
          }
          return try NorthwindLighter.withOptCString(country) { ( s ) in
            if indices.idx_country >= 0 {
              sqlite3_bind_text(statement, indices.idx_country, s, -1, nil)
            }
            return try execute()
          }
        }
      }
    }
  }
}

public extension NorthwindLighter.SalesTotalsByAmount {
  
  /**
   * Static type information for the ``SalesTotalsByAmount`` record (`Sales Totals by Amount` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_saleAmount: Int32, idx_orderID: Int32, idx_companyName: Int32, idx_shippedDate: Int32 )
    public typealias RecordType = NorthwindLighter.SalesTotalsByAmount
    
    /// The SQL table name associated with the ``SalesTotalsByAmount`` record.
    public static let externalName = "Sales Totals by Amount"
    
    /// The number of columns the `Sales Totals by Amount` table has.
    public static let columnCount : Int32 = 4
    
    /// SQL to `SELECT` all columns of the `Sales Totals by Amount` table.
    public static let select = #"SELECT "SaleAmount", "OrderID", "CompanyName", "ShippedDate" FROM "Sales Totals by Amount""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""SaleAmount", "OrderID", "CompanyName", "ShippedDate""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Sales Totals by Amount_id FROM Sales Totals by Amount`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Sales Totals by Amount_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "SaleAmount") == 0 {
          indices.idx_saleAmount = i
        }
        else if strcmp(col!, "OrderID") == 0 {
          indices.idx_orderID = i
        }
        else if strcmp(col!, "CompanyName") == 0 {
          indices.idx_companyName = i
        }
        else if strcmp(col!, "ShippedDate") == 0 {
          indices.idx_shippedDate = i
        }
      }
      return indices
    }
    
    /// Type information for property ``SalesTotalsByAmount/saleAmount`` (`SaleAmount` column).
    public let saleAmount = MappedColumn<NorthwindLighter.SalesTotalsByAmount, String?>(
      externalName: "SaleAmount",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SalesTotalsByAmount.saleAmount
    )
    
    /// Type information for property ``SalesTotalsByAmount/orderID`` (`OrderID` column).
    public let orderID = MappedColumn<NorthwindLighter.SalesTotalsByAmount, Int?>(
      externalName: "OrderID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SalesTotalsByAmount.orderID
    )
    
    /// Type information for property ``SalesTotalsByAmount/companyName`` (`CompanyName` column).
    public let companyName = MappedColumn<NorthwindLighter.SalesTotalsByAmount, String?>(
      externalName: "CompanyName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SalesTotalsByAmount.companyName
    )
    
    /// Type information for property ``SalesTotalsByAmount/shippedDate`` (`ShippedDate` column).
    public let shippedDate = MappedColumn<NorthwindLighter.SalesTotalsByAmount, String?>(
      externalName: "ShippedDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SalesTotalsByAmount.shippedDate
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ saleAmount, orderID, companyName, shippedDate ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``SalesTotalsByAmount`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Sales Totals by Amount", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = SalesTotalsByAmount(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      saleAmount: (indices.idx_saleAmount >= 0) && (indices.idx_saleAmount < argc) ? (sqlite3_column_text(statement, indices.idx_saleAmount).flatMap(String.init(cString:))) : Self.schema.saleAmount.defaultValue,
      orderID: (indices.idx_orderID >= 0) && (indices.idx_orderID < argc) ? (sqlite3_column_type(statement, indices.idx_orderID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_orderID)) : nil) : Self.schema.orderID.defaultValue,
      companyName: (indices.idx_companyName >= 0) && (indices.idx_companyName < argc) ? (sqlite3_column_text(statement, indices.idx_companyName).flatMap(String.init(cString:))) : Self.schema.companyName.defaultValue,
      shippedDate: (indices.idx_shippedDate >= 0) && (indices.idx_shippedDate < argc) ? (sqlite3_column_text(statement, indices.idx_shippedDate).flatMap(String.init(cString:))) : Self.schema.shippedDate.defaultValue
    )
  }
  
  /**
   * Bind all ``SalesTotalsByAmount`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Sales Totals by Amount SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = SalesTotalsByAmount(saleAmount: "Hello", orderID: 1, companyName: "World", shippedDate: nil)
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(saleAmount) { ( s ) in
      if indices.idx_saleAmount >= 0 {
        sqlite3_bind_text(statement, indices.idx_saleAmount, s, -1, nil)
      }
      if indices.idx_orderID >= 0 {
        if let orderID = orderID {
          sqlite3_bind_int64(statement, indices.idx_orderID, Int64(orderID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_orderID)
        }
      }
      return try NorthwindLighter.withOptCString(companyName) { ( s ) in
        if indices.idx_companyName >= 0 {
          sqlite3_bind_text(statement, indices.idx_companyName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(shippedDate) { ( s ) in
          if indices.idx_shippedDate >= 0 {
            sqlite3_bind_text(statement, indices.idx_shippedDate, s, -1, nil)
          }
          return try execute()
        }
      }
    }
  }
}

public extension NorthwindLighter.SummaryOfSalesByQuarter {
  
  /**
   * Static type information for the ``SummaryOfSalesByQuarter`` record (`Summary of Sales by Quarter` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_shippedDate: Int32, idx_orderID: Int32, idx_subtotal: Int32 )
    public typealias RecordType = NorthwindLighter.SummaryOfSalesByQuarter
    
    /// The SQL table name associated with the ``SummaryOfSalesByQuarter`` record.
    public static let externalName = "Summary of Sales by Quarter"
    
    /// The number of columns the `Summary of Sales by Quarter` table has.
    public static let columnCount : Int32 = 3
    
    /// SQL to `SELECT` all columns of the `Summary of Sales by Quarter` table.
    public static let select = #"SELECT "ShippedDate", "OrderID", "Subtotal" FROM "Summary of Sales by Quarter""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""ShippedDate", "OrderID", "Subtotal""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Summary of Sales by Quarter_id FROM Summary of Sales by Quarter`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Summary of Sales by Quarter_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "ShippedDate") == 0 {
          indices.idx_shippedDate = i
        }
        else if strcmp(col!, "OrderID") == 0 {
          indices.idx_orderID = i
        }
        else if strcmp(col!, "Subtotal") == 0 {
          indices.idx_subtotal = i
        }
      }
      return indices
    }
    
    /// Type information for property ``SummaryOfSalesByQuarter/shippedDate`` (`ShippedDate` column).
    public let shippedDate = MappedColumn<NorthwindLighter.SummaryOfSalesByQuarter, String?>(
      externalName: "ShippedDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SummaryOfSalesByQuarter.shippedDate
    )
    
    /// Type information for property ``SummaryOfSalesByQuarter/orderID`` (`OrderID` column).
    public let orderID = MappedColumn<NorthwindLighter.SummaryOfSalesByQuarter, Int?>(
      externalName: "OrderID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SummaryOfSalesByQuarter.orderID
    )
    
    /// Type information for property ``SummaryOfSalesByQuarter/subtotal`` (`Subtotal` column).
    public let subtotal = MappedColumn<NorthwindLighter.SummaryOfSalesByQuarter, String?>(
      externalName: "Subtotal",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SummaryOfSalesByQuarter.subtotal
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ shippedDate, orderID, subtotal ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``SummaryOfSalesByQuarter`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Summary of Sales by Quarter", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = SummaryOfSalesByQuarter(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      shippedDate: (indices.idx_shippedDate >= 0) && (indices.idx_shippedDate < argc) ? (sqlite3_column_text(statement, indices.idx_shippedDate).flatMap(String.init(cString:))) : Self.schema.shippedDate.defaultValue,
      orderID: (indices.idx_orderID >= 0) && (indices.idx_orderID < argc) ? (sqlite3_column_type(statement, indices.idx_orderID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_orderID)) : nil) : Self.schema.orderID.defaultValue,
      subtotal: (indices.idx_subtotal >= 0) && (indices.idx_subtotal < argc) ? (sqlite3_column_text(statement, indices.idx_subtotal).flatMap(String.init(cString:))) : Self.schema.subtotal.defaultValue
    )
  }
  
  /**
   * Bind all ``SummaryOfSalesByQuarter`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Summary of Sales by Quarter SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = SummaryOfSalesByQuarter(shippedDate: nil, orderID: 1, subtotal: "Hello")
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(shippedDate) { ( s ) in
      if indices.idx_shippedDate >= 0 {
        sqlite3_bind_text(statement, indices.idx_shippedDate, s, -1, nil)
      }
      if indices.idx_orderID >= 0 {
        if let orderID = orderID {
          sqlite3_bind_int64(statement, indices.idx_orderID, Int64(orderID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_orderID)
        }
      }
      return try NorthwindLighter.withOptCString(subtotal) { ( s ) in
        if indices.idx_subtotal >= 0 {
          sqlite3_bind_text(statement, indices.idx_subtotal, s, -1, nil)
        }
        return try execute()
      }
    }
  }
}

public extension NorthwindLighter.SummaryOfSalesByYear {
  
  /**
   * Static type information for the ``SummaryOfSalesByYear`` record (`Summary of Sales by Year` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_shippedDate: Int32, idx_orderID: Int32, idx_subtotal: Int32 )
    public typealias RecordType = NorthwindLighter.SummaryOfSalesByYear
    
    /// The SQL table name associated with the ``SummaryOfSalesByYear`` record.
    public static let externalName = "Summary of Sales by Year"
    
    /// The number of columns the `Summary of Sales by Year` table has.
    public static let columnCount : Int32 = 3
    
    /// SQL to `SELECT` all columns of the `Summary of Sales by Year` table.
    public static let select = #"SELECT "ShippedDate", "OrderID", "Subtotal" FROM "Summary of Sales by Year""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""ShippedDate", "OrderID", "Subtotal""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Summary of Sales by Year_id FROM Summary of Sales by Year`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Summary of Sales by Year_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "ShippedDate") == 0 {
          indices.idx_shippedDate = i
        }
        else if strcmp(col!, "OrderID") == 0 {
          indices.idx_orderID = i
        }
        else if strcmp(col!, "Subtotal") == 0 {
          indices.idx_subtotal = i
        }
      }
      return indices
    }
    
    /// Type information for property ``SummaryOfSalesByYear/shippedDate`` (`ShippedDate` column).
    public let shippedDate = MappedColumn<NorthwindLighter.SummaryOfSalesByYear, String?>(
      externalName: "ShippedDate",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SummaryOfSalesByYear.shippedDate
    )
    
    /// Type information for property ``SummaryOfSalesByYear/orderID`` (`OrderID` column).
    public let orderID = MappedColumn<NorthwindLighter.SummaryOfSalesByYear, Int?>(
      externalName: "OrderID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SummaryOfSalesByYear.orderID
    )
    
    /// Type information for property ``SummaryOfSalesByYear/subtotal`` (`Subtotal` column).
    public let subtotal = MappedColumn<NorthwindLighter.SummaryOfSalesByYear, String?>(
      externalName: "Subtotal",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SummaryOfSalesByYear.subtotal
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ shippedDate, orderID, subtotal ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``SummaryOfSalesByYear`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Summary of Sales by Year", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = SummaryOfSalesByYear(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      shippedDate: (indices.idx_shippedDate >= 0) && (indices.idx_shippedDate < argc) ? (sqlite3_column_text(statement, indices.idx_shippedDate).flatMap(String.init(cString:))) : Self.schema.shippedDate.defaultValue,
      orderID: (indices.idx_orderID >= 0) && (indices.idx_orderID < argc) ? (sqlite3_column_type(statement, indices.idx_orderID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_orderID)) : nil) : Self.schema.orderID.defaultValue,
      subtotal: (indices.idx_subtotal >= 0) && (indices.idx_subtotal < argc) ? (sqlite3_column_text(statement, indices.idx_subtotal).flatMap(String.init(cString:))) : Self.schema.subtotal.defaultValue
    )
  }
  
  /**
   * Bind all ``SummaryOfSalesByYear`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Summary of Sales by Year SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = SummaryOfSalesByYear(shippedDate: nil, orderID: 1, subtotal: "Hello")
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(shippedDate) { ( s ) in
      if indices.idx_shippedDate >= 0 {
        sqlite3_bind_text(statement, indices.idx_shippedDate, s, -1, nil)
      }
      if indices.idx_orderID >= 0 {
        if let orderID = orderID {
          sqlite3_bind_int64(statement, indices.idx_orderID, Int64(orderID))
        }
        else {
          sqlite3_bind_null(statement, indices.idx_orderID)
        }
      }
      return try NorthwindLighter.withOptCString(subtotal) { ( s ) in
        if indices.idx_subtotal >= 0 {
          sqlite3_bind_text(statement, indices.idx_subtotal, s, -1, nil)
        }
        return try execute()
      }
    }
  }
}

public extension NorthwindLighter.CategorySalesFor1997 {
  
  /**
   * Static type information for the ``CategorySalesFor1997`` record (`Category Sales for 1997` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_categoryName: Int32, idx_categorySales: Int32 )
    public typealias RecordType = NorthwindLighter.CategorySalesFor1997
    
    /// The SQL table name associated with the ``CategorySalesFor1997`` record.
    public static let externalName = "Category Sales for 1997"
    
    /// The number of columns the `Category Sales for 1997` table has.
    public static let columnCount : Int32 = 2
    
    /// SQL to `SELECT` all columns of the `Category Sales for 1997` table.
    public static let select = #"SELECT "CategoryName", "CategorySales" FROM "Category Sales for 1997""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CategoryName", "CategorySales""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Category Sales for 1997_id FROM Category Sales for 1997`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Category Sales for 1997_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CategoryName") == 0 {
          indices.idx_categoryName = i
        }
        else if strcmp(col!, "CategorySales") == 0 {
          indices.idx_categorySales = i
        }
      }
      return indices
    }
    
    /// Type information for property ``CategorySalesFor1997/categoryName`` (`CategoryName` column).
    public let categoryName = MappedColumn<NorthwindLighter.CategorySalesFor1997, String?>(
      externalName: "CategoryName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CategorySalesFor1997.categoryName
    )
    
    /// Type information for property ``CategorySalesFor1997/categorySales`` (`CategorySales` column).
    public let categorySales = MappedColumn<NorthwindLighter.CategorySalesFor1997, String?>(
      externalName: "CategorySales",
      defaultValue: nil,
      keyPath: \NorthwindLighter.CategorySalesFor1997.categorySales
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ categoryName, categorySales ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``CategorySalesFor1997`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Category Sales for 1997", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = CategorySalesFor1997(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      categoryName: (indices.idx_categoryName >= 0) && (indices.idx_categoryName < argc) ? (sqlite3_column_text(statement, indices.idx_categoryName).flatMap(String.init(cString:))) : Self.schema.categoryName.defaultValue,
      categorySales: (indices.idx_categorySales >= 0) && (indices.idx_categorySales < argc) ? (sqlite3_column_text(statement, indices.idx_categorySales).flatMap(String.init(cString:))) : Self.schema.categorySales.defaultValue
    )
  }
  
  /**
   * Bind all ``CategorySalesFor1997`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Category Sales for 1997 SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = CategorySalesFor1997(categoryName: "Hello", categorySales: "World")
   * let ok = record.bind(to: statement, indices: ( 1, 2 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    return try NorthwindLighter.withOptCString(categoryName) { ( s ) in
      if indices.idx_categoryName >= 0 {
        sqlite3_bind_text(statement, indices.idx_categoryName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(categorySales) { ( s ) in
        if indices.idx_categorySales >= 0 {
          sqlite3_bind_text(statement, indices.idx_categorySales, s, -1, nil)
        }
        return try execute()
      }
    }
  }
}

public extension NorthwindLighter.OrderDetailsExtended {
  
  /**
   * Static type information for the ``OrderDetailsExtended`` record (`Order Details Extended` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_orderID: Int32, idx_productID: Int32, idx_productName: Int32, idx_unitPrice: Int32, idx_quantity: Int32, idx_discount: Int32, idx_extendedPrice: Int32 )
    public typealias RecordType = NorthwindLighter.OrderDetailsExtended
    
    /// The SQL table name associated with the ``OrderDetailsExtended`` record.
    public static let externalName = "Order Details Extended"
    
    /// The number of columns the `Order Details Extended` table has.
    public static let columnCount : Int32 = 7
    
    /// SQL to `SELECT` all columns of the `Order Details Extended` table.
    public static let select = #"SELECT "OrderID", "ProductID", "ProductName", "UnitPrice", "Quantity", "Discount", "ExtendedPrice" FROM "Order Details Extended""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""OrderID", "ProductID", "ProductName", "UnitPrice", "Quantity", "Discount", "ExtendedPrice""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3, 4, 5, 6 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Order Details Extended_id FROM Order Details Extended`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Order Details Extended_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "OrderID") == 0 {
          indices.idx_orderID = i
        }
        else if strcmp(col!, "ProductID") == 0 {
          indices.idx_productID = i
        }
        else if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
        else if strcmp(col!, "UnitPrice") == 0 {
          indices.idx_unitPrice = i
        }
        else if strcmp(col!, "Quantity") == 0 {
          indices.idx_quantity = i
        }
        else if strcmp(col!, "Discount") == 0 {
          indices.idx_discount = i
        }
        else if strcmp(col!, "ExtendedPrice") == 0 {
          indices.idx_extendedPrice = i
        }
      }
      return indices
    }
    
    /// Type information for property ``OrderDetailsExtended/orderID`` (`OrderID` column).
    public let orderID = MappedColumn<NorthwindLighter.OrderDetailsExtended, Int?>(
      externalName: "OrderID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderDetailsExtended.orderID
    )
    
    /// Type information for property ``OrderDetailsExtended/productID`` (`ProductID` column).
    public let productID = MappedColumn<NorthwindLighter.OrderDetailsExtended, Int?>(
      externalName: "ProductID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderDetailsExtended.productID
    )
    
    /// Type information for property ``OrderDetailsExtended/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.OrderDetailsExtended, String?>(
      externalName: "ProductName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderDetailsExtended.productName
    )
    
    /// Type information for property ``OrderDetailsExtended/unitPrice`` (`UnitPrice` column).
    public let unitPrice = MappedColumn<NorthwindLighter.OrderDetailsExtended, String?>(
      externalName: "UnitPrice",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderDetailsExtended.unitPrice
    )
    
    /// Type information for property ``OrderDetailsExtended/quantity`` (`Quantity` column).
    public let quantity = MappedColumn<NorthwindLighter.OrderDetailsExtended, Int?>(
      externalName: "Quantity",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderDetailsExtended.quantity
    )
    
    /// Type information for property ``OrderDetailsExtended/discount`` (`Discount` column).
    public let discount = MappedColumn<NorthwindLighter.OrderDetailsExtended, Double?>(
      externalName: "Discount",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderDetailsExtended.discount
    )
    
    /// Type information for property ``OrderDetailsExtended/extendedPrice`` (`ExtendedPrice` column).
    public let extendedPrice = MappedColumn<NorthwindLighter.OrderDetailsExtended, String?>(
      externalName: "ExtendedPrice",
      defaultValue: nil,
      keyPath: \NorthwindLighter.OrderDetailsExtended.extendedPrice
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ orderID, productID, productName, unitPrice, quantity, discount, extendedPrice ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``OrderDetailsExtended`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Order Details Extended", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = OrderDetailsExtended(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      orderID: (indices.idx_orderID >= 0) && (indices.idx_orderID < argc) ? (sqlite3_column_type(statement, indices.idx_orderID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_orderID)) : nil) : Self.schema.orderID.defaultValue,
      productID: (indices.idx_productID >= 0) && (indices.idx_productID < argc) ? (sqlite3_column_type(statement, indices.idx_productID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_productID)) : nil) : Self.schema.productID.defaultValue,
      productName: (indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : Self.schema.productName.defaultValue,
      unitPrice: (indices.idx_unitPrice >= 0) && (indices.idx_unitPrice < argc) ? (sqlite3_column_text(statement, indices.idx_unitPrice).flatMap(String.init(cString:))) : Self.schema.unitPrice.defaultValue,
      quantity: (indices.idx_quantity >= 0) && (indices.idx_quantity < argc) ? (sqlite3_column_type(statement, indices.idx_quantity) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_quantity)) : nil) : Self.schema.quantity.defaultValue,
      discount: (indices.idx_discount >= 0) && (indices.idx_discount < argc) ? (sqlite3_column_type(statement, indices.idx_discount) != SQLITE_NULL ? sqlite3_column_double(statement, indices.idx_discount) : nil) : Self.schema.discount.defaultValue,
      extendedPrice: (indices.idx_extendedPrice >= 0) && (indices.idx_extendedPrice < argc) ? (sqlite3_column_text(statement, indices.idx_extendedPrice).flatMap(String.init(cString:))) : Self.schema.extendedPrice.defaultValue
    )
  }
  
  /**
   * Bind all ``OrderDetailsExtended`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Order Details Extended SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = OrderDetailsExtended(orderID: 1, productID: 2, productName: "Hello", unitPrice: "World")
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4, 5, 6, 7 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_orderID >= 0 {
      if let orderID = orderID {
        sqlite3_bind_int64(statement, indices.idx_orderID, Int64(orderID))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_orderID)
      }
    }
    if indices.idx_productID >= 0 {
      if let productID = productID {
        sqlite3_bind_int64(statement, indices.idx_productID, Int64(productID))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_productID)
      }
    }
    return try NorthwindLighter.withOptCString(productName) { ( s ) in
      if indices.idx_productName >= 0 {
        sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(unitPrice) { ( s ) in
        if indices.idx_unitPrice >= 0 {
          sqlite3_bind_text(statement, indices.idx_unitPrice, s, -1, nil)
        }
        if indices.idx_quantity >= 0 {
          if let quantity = quantity {
            sqlite3_bind_int64(statement, indices.idx_quantity, Int64(quantity))
          }
          else {
            sqlite3_bind_null(statement, indices.idx_quantity)
          }
        }
        if indices.idx_discount >= 0 {
          if let discount = discount {
            sqlite3_bind_double(statement, indices.idx_discount, discount)
          }
          else {
            sqlite3_bind_null(statement, indices.idx_discount)
          }
        }
        return try NorthwindLighter.withOptCString(extendedPrice) { ( s ) in
          if indices.idx_extendedPrice >= 0 {
            sqlite3_bind_text(statement, indices.idx_extendedPrice, s, -1, nil)
          }
          return try execute()
        }
      }
    }
  }
}

public extension NorthwindLighter.SalesByCategory {
  
  /**
   * Static type information for the ``SalesByCategory`` record (`Sales by Category` SQL table).
   *
   * This structure captures the static SQL information associated with the
   * record.
   * It is used for static type lookups and more.
   */
  struct Schema : SQLViewSchema {
    
    public typealias PropertyIndices = ( idx_categoryID: Int32, idx_categoryName: Int32, idx_productName: Int32, idx_productSales: Int32 )
    public typealias RecordType = NorthwindLighter.SalesByCategory
    
    /// The SQL table name associated with the ``SalesByCategory`` record.
    public static let externalName = "Sales by Category"
    
    /// The number of columns the `Sales by Category` table has.
    public static let columnCount : Int32 = 4
    
    /// SQL to `SELECT` all columns of the `Sales by Category` table.
    public static let select = #"SELECT "CategoryID", "CategoryName", "ProductName", "ProductSales" FROM "Sales by Category""#
    
    /// SQL fragment representing all columns.
    public static let selectColumns = #""CategoryID", "CategoryName", "ProductName", "ProductSales""#
    
    /// Index positions of the properties in ``selectColumns``.
    public static let selectColumnIndices : PropertyIndices = ( 0, 1, 2, 3 )
    
    /**
     * Lookup property indices by column name in a statement handle.
     *
     * Properties are ordered in the schema and have a specific index
     * assigned.
     * E.g. if the record has two properties, `id` and `name`,
     * and the query was `SELECT age, Sales by Category_id FROM Sales by Category`,
     * this would return `( idx_id: 1, idx_name: -1 )`.
     * Because the `Sales by Category_id` is in the second position and `name`
     * isn't provided at all.
     *
     * - Parameters:
     *   - statement: A raw SQLite3 prepared statement handle.
     * - Returns: The positions of the properties in the prepared statement.
     */
    @inlinable
    public static func lookupColumnIndices(`in` statement: OpaquePointer!)
      -> PropertyIndices
    {
      var indices : PropertyIndices = ( -1, -1, -1, -1 )
      for i in 0..<sqlite3_column_count(statement) {
        let col = sqlite3_column_name(statement, i)
        if strcmp(col!, "CategoryID") == 0 {
          indices.idx_categoryID = i
        }
        else if strcmp(col!, "CategoryName") == 0 {
          indices.idx_categoryName = i
        }
        else if strcmp(col!, "ProductName") == 0 {
          indices.idx_productName = i
        }
        else if strcmp(col!, "ProductSales") == 0 {
          indices.idx_productSales = i
        }
      }
      return indices
    }
    
    /// Type information for property ``SalesByCategory/categoryID`` (`CategoryID` column).
    public let categoryID = MappedColumn<NorthwindLighter.SalesByCategory, Int?>(
      externalName: "CategoryID",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SalesByCategory.categoryID
    )
    
    /// Type information for property ``SalesByCategory/categoryName`` (`CategoryName` column).
    public let categoryName = MappedColumn<NorthwindLighter.SalesByCategory, String?>(
      externalName: "CategoryName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SalesByCategory.categoryName
    )
    
    /// Type information for property ``SalesByCategory/productName`` (`ProductName` column).
    public let productName = MappedColumn<NorthwindLighter.SalesByCategory, String?>(
      externalName: "ProductName",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SalesByCategory.productName
    )
    
    /// Type information for property ``SalesByCategory/productSales`` (`ProductSales` column).
    public let productSales = MappedColumn<NorthwindLighter.SalesByCategory, String?>(
      externalName: "ProductSales",
      defaultValue: nil,
      keyPath: \NorthwindLighter.SalesByCategory.productSales
    )
    
    #if swift(>=5.7)
    public var _allColumns : [ any SQLColumn ] { [ categoryID, categoryName, productName, productSales ] }
    #endif // swift(>=5.7)
  }
  
  /**
   * Initialize a ``SalesByCategory`` record from a SQLite statement handle.
   *
   * This initializer allows easy setup of a record structure from an
   * otherwise arbitrarily constructed SQLite prepared statement.
   *
   * If no `indices` are specified, the `Schema/lookupColumnIndices`
   * function will be used to find the positions of the structure properties
   * based on their external name.
   * When looping, it is recommended to do the lookup once, and then
   * provide the `indices` to the initializer.
   *
   * Required values that are missing in the statement are replaced with
   * their assigned default values, i.e. this can even be used to perform
   * partial selects w/ only a minor overhead (the extra space for a
   * record).
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(dbHandle, "SELECT * FROM Sales by Category", -1, &statement, nil)
   * while sqlite3_step(statement) == SQLITE_ROW {
   *   let record = SalesByCategory(statement)
   *   print("Fetched:", record)
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: Statement handle as returned by `sqlite3_prepare*` functions.
   *   - indices: Property bindings positions, defaults to `nil` (automatic lookup).
   */
  @inlinable
  init(_ statement: OpaquePointer!, indices: Schema.PropertyIndices? = nil)
  {
    let indices = indices ?? Self.Schema.lookupColumnIndices(in: statement)
    let argc = sqlite3_column_count(statement)
    self.init(
      categoryID: (indices.idx_categoryID >= 0) && (indices.idx_categoryID < argc) ? (sqlite3_column_type(statement, indices.idx_categoryID) != SQLITE_NULL ? Int(sqlite3_column_int64(statement, indices.idx_categoryID)) : nil) : Self.schema.categoryID.defaultValue,
      categoryName: (indices.idx_categoryName >= 0) && (indices.idx_categoryName < argc) ? (sqlite3_column_text(statement, indices.idx_categoryName).flatMap(String.init(cString:))) : Self.schema.categoryName.defaultValue,
      productName: (indices.idx_productName >= 0) && (indices.idx_productName < argc) ? (sqlite3_column_text(statement, indices.idx_productName).flatMap(String.init(cString:))) : Self.schema.productName.defaultValue,
      productSales: (indices.idx_productSales >= 0) && (indices.idx_productSales < argc) ? (sqlite3_column_text(statement, indices.idx_productSales).flatMap(String.init(cString:))) : Self.schema.productSales.defaultValue
    )
  }
  
  /**
   * Bind all ``SalesByCategory`` properties to a prepared statement and call a closure.
   *
   * *Important*: The bindings are only valid within the closure being executed!
   *
   * Example:
   * ```swift
   * var statement : OpaquePointer?
   * sqlite3_prepare_v2(
   *   dbHandle,
   *   #"UPDATE Sales by Category SET lastname = ?, firstname = ? WHERE person_id = ?"#,
   *   -1, &statement, nil
   * )
   *
   * let record = SalesByCategory(categoryID: 1, categoryName: "Hello", productName: "World", productSales: "Duck")
   * let ok = record.bind(to: statement, indices: ( 1, 2, 3, 4 )) {
   *   sqlite3_step(statement) == SQLITE_DONE
   * }
   * sqlite3_finalize(statement)
   * ```
   *
   * - Parameters:
   *   - statement: A SQLite3 statement handle as returned by the `sqlite3_prepare*` functions.
   *   - indices: The parameter positions for the bindings.
   *   - execute: Closure executed with bindings applied, bindings _only_ valid within the call!
   * - Returns: Returns the result of the closure that is passed in.
   */
  @inlinable
  @discardableResult
  func bind<R>(
    to statement: OpaquePointer!,
    indices: Schema.PropertyIndices,
    then execute: () throws -> R
  ) rethrows -> R
  {
    if indices.idx_categoryID >= 0 {
      if let categoryID = categoryID {
        sqlite3_bind_int64(statement, indices.idx_categoryID, Int64(categoryID))
      }
      else {
        sqlite3_bind_null(statement, indices.idx_categoryID)
      }
    }
    return try NorthwindLighter.withOptCString(categoryName) { ( s ) in
      if indices.idx_categoryName >= 0 {
        sqlite3_bind_text(statement, indices.idx_categoryName, s, -1, nil)
      }
      return try NorthwindLighter.withOptCString(productName) { ( s ) in
        if indices.idx_productName >= 0 {
          sqlite3_bind_text(statement, indices.idx_productName, s, -1, nil)
        }
        return try NorthwindLighter.withOptCString(productSales) { ( s ) in
          if indices.idx_productSales >= 0 {
            sqlite3_bind_text(statement, indices.idx_productSales, s, -1, nil)
          }
          return try execute()
        }
      }
    }
  }
}
