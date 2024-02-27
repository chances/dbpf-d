/// Network Rules
///
/// See_Also: $(UL
///   $(LI `dbpf.KnownTgis`)
///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=RUL_File">RUL file</a> (SC4D Encyclopedia))
/// )
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2024 Chance Snow. All rights reserved.
/// License: MIT License
module dbpf.files.rul;

/// See_Also: `dbpf.KnownTgis`
enum NetworkId : ushort {
  /// Road
  road = 0x0,
  /// Rail
  rail = 0x1,
  /// Elevated Maxis Highway
  elevatedHighway = 0x2,
  /// Street
  street = 0x3,
  /// Pipe
  pipe = 0x4,
  /// PowerLine
  powerLine = 0x5,
  /// Avenue
  avenue = 0x6,
  /// Subway
  subway = 0x7,
  /// Light Rail
  lightRail = 0x8,
  /// Monorail
  monorail = 0x9,
  /// OneWayRoad
  oneWayRoad = 0xA,
  /// Dirt Road/RHW
  dirtRoad = 0xB,
  /// Ground Maxis Highway
  groundHighway = 0xC,
}
