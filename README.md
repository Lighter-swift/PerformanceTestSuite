<h2>Lighter Performance Test Suite
  <img src="https://zeezide.com/img/lighter/Lighter256.png"
       align="right" width="64" height="64" />
</h2>

This repository contains code to test the Lighter performance.
It uses the (populated)
[Northwind SQLite](https://github.com/jpwhite3/northwind-SQLite3/)
database as the base set.
It doesn't have the goal to be scientifically proper.

### Results

It evaluates the load performance on queries against the "Orders" table,
which has 16K records. The test loads all 16K records on each iteration.

Lighter is expected to perform excellent, as it directly/statically binds
SQLite prepared statements for the generated structures.

M1 Mini with 10 rampup iterations and 500 test iterations.
```
Orders.fetchAll    setup    rampup   duration
  Enlighter SQLite 0        0,135s     6,629s   ~20% faster than Lighter (75/s)
  Lighter          0        0,162s     7,927s   Baseline                 (63/s)
  GRDB             -        -        ~12s       Handwritten Mapping
  SQLite.swift     0        0,613s    30,643s   Handwritten Mapping (>3× slower) (16/s)
  GRDB             0,001    0,995s    49,404s   Codable (>6× slower)     (10/s)
  SQLite.swift     0,001    3,109s   153,172s   Codable (>19× slower)    (3/s)
```

Essentially the specific testcase with no handcrafting involved needs 30 secs
on GRDB, which is state of the art, 2.5 minutes w/ SQLite.swift and
not about 8 secs with the Lighter API.

As a chart:
```
┌─────────────────────────────────────────────────────────────────────────────┐
├─┐                                                                           │
│S│                Enlighter generated raw SQLite API Bindings   ~20% faster  │
├─┘                                                                           │
├──┐                                                                          │
│L3│               Lighter, w/ high level API (baseline)            Baseline  │
├──┘                                                                          │
├─────┐                                                                       │
│GRDB │            with handwritten record mappings              ~50% slower  │
├─────┘                                                                       │
├─────────────┐                                                               │
│SQLite.swift │    with handwritten record mappings               >3× slower  │
├─────────────┘                                                               │
├───────────────────────┐                                                     │
│GRDB with Codable      │                                         >6× slower  │
├───────────────────────┘                                                     │
├───────────────────────────────────────────────────────────────────────────┐ │
│SQLite.swift with Codable                                       >19× slower│ │
├───────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
      Time to load the Northwind "Products" table 500 times into a model.      
                              Shorter is faster.                               
```

*Main takeway*: Never ever use Codable.

#### TODO

- [ ] CoreData performance test (replicate schema, load records via Lighter)
- [x] Add a test for GRDB Codable
- [x] Add a test for SQLite.swift Codable
- [x] Add a test for SQLite.swift w/o Codable, with hand written mappings
- [x] Lighter API Tests
- [x] Enlighter generated raw SQLite API Tests


### Test Environment

#### Northwind

- [Northwind SQLite](https://github.com/jpwhite3/northwind-SQLite3/)
  - the larger one (make populate) is 24MB, the small 602KB
    - 9 employees
    - 93 customers
    - 16k orders, 560k details
    - 4 regions

```bash
$ cd /tmp
$ git clone https://github.com/jpwhite3/northwind-SQLite3
$ cd northwind-SQLite3
$ make build populate
rm -rf ./dist
mkdir ./dist
sqlite3 dist/northwind.db < src/create.sql > /dev/null
sqlite3 dist/northwind.db < src/update.sql > /dev/null
sqlite3 dist/northwind.db < src/report.sql
Categories|8
CustomerCustomerDemo|0
CustomerDemographics|0
Customers|93
EmployeeTerritories|49
Employees|9
Details|2155
Orders|830
Products|77
Regions|4
Shippers|3
Suppliers|29
Territories|53
python3 ./src/populate.py
sqlite3 dist/northwind.db < src/report.sql
Categories|8
CustomerCustomerDemo|0
CustomerDemographics|0
Customers|93
EmployeeTerritories|49
Employees|9
Details|588936      <==
Orders|15889        <==
Products|77
Regions|4
Shippers|3
Suppliers|29
Territories|53

$ ls -lh dist
-rw-r--r--  1 helge  wheel    23M Aug  6 11:05 northwind.db

$ sqlite3 -readonly dist/northwind.db 
SQLite version 3.37.0 2021-12-09 01:34:53
sqlite> SELECT COUNT(*) FROM "Orders";
15889
sqlite> SELECT COUNT(*) FROM "Order Details";
588936
```

```sql
CREATE TABLE [Orders](
  [OrderID]        INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  [CustomerID]     TEXT,
  [EmployeeID]     INTEGER,
  [OrderDate]      DATETIME, -- 2019-02-10 04:59:33
  [RequiredDate]   DATETIME,
  [ShippedDate]    DATETIME,
  [ShipVia]        INTEGER,
  [Freight]        NUMERIC DEFAULT 0,
  [ShipName]       TEXT,
  [ShipAddress]    TEXT,
  [ShipCity]       TEXT,
  [ShipRegion]     TEXT,
  [ShipPostalCode] TEXT,
  [ShipCountry]    TEXT,
  
  FOREIGN KEY ([EmployeeID]) 
    REFERENCES [Employees] ([EmployeeID]) 
      ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ([CustomerID]) 
    REFERENCES [Customers] ([CustomerID]) 
      ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ([ShipVia]) 
    REFERENCES [Shippers] ([ShipperID]) 
      ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [Order Details](
  [OrderID]   INTEGER NOT NULL,
  [ProductID] INTEGER NOT NULL,
  [UnitPrice] NUMERIC NOT NULL DEFAULT 0,
  [Quantity]  INTEGER NOT NULL DEFAULT 1,
  [Discount]  REAL    NOT NULL DEFAULT 0,
  
  PRIMARY KEY ("OrderID","ProductID"),
  CHECK ([Discount]>=(0) AND [Discount]<=(1)),
  CHECK ([Quantity]>(0)),
  CHECK ([UnitPrice]>=(0)),
  
  FOREIGN KEY ([OrderID]) 
    REFERENCES [Orders] ([OrderID]) 
      ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ([ProductID]) 
    REFERENCES [Products] ([ProductID]) 
      ON DELETE NO ACTION ON UPDATE NO ACTION
);
```

#### GRDB

- [GRDB](https://github.com/groue/GRDB.swift)
  - Add as package dependency 5.26.0

```bash
$ cd /tmp
$ git clone https://github.com/groue/GRDB.swift
$ cd GRDB.swift/
$ git checkout v5.26.0
$ du -sh .
232M  .
$ pushd Tests/Performance/GRDBProfiling/GRDBProfiling
sqlite> .schema
CREATE TABLE items (i0 INT, i1 INT, i2 INT, i3 INT, i4 INT, i5 INT, i6 INT, i7 INT, i8 INT, i9 INT);
sqlite> SELECT COUNT(*) FROM items;
100000
```

#### Lighter

- [Lighter.swift](git@github.com:55DB091A-8471-447B-8F50-5DFF4C1B14AC/Lighter.git)
  - Add as package dependency

#### SQLite.swift

- [SQLite.swift](https://github.com/stephencelis/SQLite.swift)
  - Add as package dependency (0.13.3)


#### Bun.sh

- [Bun](https://bun.sh) is a new JavaScript runtime which claims to be
  extremely fast and has SQLite test specifically. 
  It claims to be ~3x faster than Node.js w/ better-sqlite3 and 6x faster
  than Deno.

```bash
$ curl https://bun.sh/install | bash
bun was installed successfully to ~/.bun/bin/bun 

Manually add the directory to ~/.zshrc (or similar):
  export BUN_INSTALL="$HOME/.bun" 
  export PATH="$BUN_INSTALL/bin:$PATH" 

$ bun --version
0.1.7
```

```bash
$ git clone https://github.com/oven-sh/bun.git
$ cd bun/bench/sqlite
```
- Adjust dbfile to point to "/tmp/northwind-SQLite3/dist/northwind.db"
- Restrict test to "Orders" table (also rename from "Order")
```bash
$ bun query.js
cpu: unknown
runtime: bun 0.1.2 (arm64-darwin) 

benchmark                   time (avg)             (min … max)       p75       p99      p995
-------------------------------------------------------------- -----------------------------
SELECT * FROM "Orders"   13.04 ms/iter   (12.56 ms … 14.74 ms)  12.97 ms  14.74 ms  14.74 ms
```

That actually matches Lighter, it probably is the baseline SQLite3 performance
with no mapping overheader (Lighter almost has zero, except for Swift String 
creation).

Presumably this doesn't include any garbage collection in bun, 
while the Swift tests free the records in each iteration via ARC.


### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.

**Want to support my work**?
Buy an app:
[Past for iChat](https://apps.apple.com/us/app/past-for-ichat/id1554897185),
[SVG Shaper](https://apps.apple.com/us/app/svg-shaper-for-swiftui/id1566140414),
[Shrugs](https://shrugs.app/),
[HMScriptEditor](https://apps.apple.com/us/app/hmscripteditor/id1483239744).
You don't have to use it! 😀
