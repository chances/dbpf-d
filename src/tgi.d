/// Authors: Chance Snow
/// Copyright: Copyright © 2024 Chance Snow. All rights reserved.
/// License: MIT License
module dbpf.tgi;

/// Type Group Instance
///
/// Used to identify, reference, and link files within DBPF archives.
/// Remarks:
/// As TGI's are relatively unique to a particular object, they are the preferred method for referencing game objects,
/// which might have multiple names in a variety of languages or naming conventions. Additionally, objects sometimes
/// have very similar names, making the TGI an ideal way to differentiate between the two.
/// See_Also: $(UL
///   $(LI `KnownTgis`)
///   $(LI `Entry`)
///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=TGI">TGI</a> (SC4D Encyclopedia))
/// )
struct Tgi {
align(1):
  /// Type ID
  /// See_Also: <a href="https://wiki.sc4devotion.com/index.php?title=Type_ID">Type ID</a> (SC4D Encyclopedia)
  uint typeId;
  /// Group ID
  /// See_Also: <a href="https://wiki.sc4devotion.com/index.php?title=Group_ID">Group ID</a> (SC4D Encyclopedia)
  uint groupId;
  /// Instance ID
  /// See_Also: <a href="https://wiki.sc4devotion.com/index.php?title=Instance_ID">Instance ID</a> (SC4D Encyclopedia)
  uint instanceId;
}

static assert(Tgi.alignof == 1);
static assert(Tgi.sizeof == 12);

///
enum KnownTgis : Tgi {
  /// DataBase Directory Files
  /// See_Also: <a href="https://wiki.sc4devotion.com/index.php?title=DBDF">DBDF file</a> a.k.a. DIR (SC4D Encyclopedia)
  dir = Tgi(0xE86B1EEF, 0xE86B1EEF, 0x286B1F03),
  /// Intersection Ordering: Ploppable Network Rule
  /// See_Also: $(UL
  ///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=RUL0">Intersection Ordering</a> (SC4D Encyclopedia))
  ///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=Puzzle_Piece">Ploppable network piece</a> (SC4D Encyclopedia))
  ///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=RUL_File">RUL file</a> (SC4D Encyclopedia))
  /// )
  intersectionOrdering = Tgi(0X0A5BCF4B, 0XAA5BCF57, 0x10000000),
  /// Intersection Ordering Network Rule
  /// See_Also: $(UL
  ///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=RUL1">Intersection Ordering</a> (SC4D Encyclopedia))
  ///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=RUL_File">RUL file</a> (SC4D Encyclopedia))
  /// )
  intersectionSolutions = Tgi(0X0A5BCF4B, 0XAA5BCF57, 0x10000001),
  /// Network Overrides
  /// See_Also: $(UL
  ///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=RUL2">Network Overrides</a> (SC4D Encyclopedia))
  ///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=RUL_File">RUL file</a> (SC4D Encyclopedia))
  /// )
  networkOverrides = Tgi(0X0A5BCF4B, 0XAA5BCF57, 0x10000002),
  /// Bridge Network Rule, one per Network ID.
  ///
  /// Layout information for complex bridges, and allow for more control over custom bridges. Instance IDs are
  /// formatted `0x0000100N` where `N` is the Network ID.
  /// Note: Not required for all bridges, and not all network types have a corresponding Bridge RUL file.
  /// See_Also: $(UL
  ///   $(LI `NetworkId`)
  ///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=Bridge_RUL">Bridge RUL file</a> (SC4D Encyclopedia))
  /// )
  roadBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001000),
  /// ditto
  railBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001001),
  /// ditto
  elevatedHighwayBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001002),
  /// ditto
  streetBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001003),
  /// ditto
  pipeBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001004),
  /// ditto
  powerLineBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001005),
  /// ditto
  avenueBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001006),
  /// ditto
  subwayBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001007),
  /// ditto
  lightRailBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001008),
  /// ditto
  monorailBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x00001009),
  /// ditto
  oneWayRoadBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000100A),
  /// ditto
  dirtRoadBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000100B),
  /// ditto
  groundHighwayBridge = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000100C),
  /// Elevated Highway Basic RUL
  elevatedHighwayRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000001),
  /// Elevated Highway Advanced RUL
  elevatedHighwayAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000002),
  /// Pipe Basic RUL
  pipeRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000003),
  /// Pipe Advanced RUL
  pipeAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000004),
  /// Rail Basic RUL
  railRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000005),
  /// Rail Advanced RUL
  railAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000006),
  /// Road Basic RUL
  roadRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000007),
  /// Road Advanced RUL
  roadAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000008),
  /// Street Basic RUL
  streetRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000009),
  /// Street Advanced RUL
  streetAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x000000A),
  /// Subway Basic RUL
  subwayRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x000000B),
  /// Subway Advanced RUL
  subwayAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x000000C),
  /// Avenue Basic RUL
  avenueRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x000000D),
  /// Avenue Advanced RUL
  avenueAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x000000E),
  /// Elevated Rail Basic RUL
  elevatedRailRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x000000F),
  /// Elevated Rail Advanced RUL
  elevatedRailAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000010),
  /// One-Way Road Basic RUL
  oneWayRoadRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000011),
  /// One-Way Road Advanced RUL
  oneWayRoadAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000012),
  /// RHW ("Dirt Road") Basic RUL
  dirtRoadRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000013),
  /// RHW ("Dirt Road") Advanced RUL
  dirtRoadAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000014),
  /// Monorail Basic RUL
  monorailRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000015),
  /// Monorail Advanced RUL
  monorailAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000016),
  /// Ground Highway Basic RUL
  groundHighwayRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000017),
  /// Ground Highway Advanced RUL
  groundHighwayAdvancedRule = Tgi(0x0A5BCF4B, 0xAA5BCF57, 0x0000018),
}
