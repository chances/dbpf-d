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

import pry;
static import std.typecons;

import dbpf.files;

/// See_Also: `dbpf.KnownTgis`
enum NetworkId : ubyte {
  ///
  undefined = ubyte.max,
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
  /// ditto
  highway = 0xC,
}

/// Convert the integer representation of a Network ID to its string equivalent.
/// See_Also: $(UL
///   $(LI `NetworkId`)
///   $(LI <a href="https://wiki.sc4devotion.com/index.php?title=Individual_Network_RULs#Header">Individual Network Rules: Header</a> (SC4D Encyclopedia))
/// )
string transitType(NetworkId network) {
  final switch (network) {
    case NetworkId.undefined: assert(0);
    case NetworkId.road: return "Road";
    case NetworkId.rail: return "Rail";
    case NetworkId.elevatedHighway: return "ElevatedHighway";
    case NetworkId.street: return "Street";
    case NetworkId.pipe: return "Pipe";
    case NetworkId.powerLine: return "PowerLine";
    case NetworkId.avenue: return "Avenue";
    case NetworkId.subway: return "Subway";
    case NetworkId.lightRail: return "LightRail";
    case NetworkId.monorail: return "Monorail";
    case NetworkId.oneWayRoad: return "OneWayRoad";
    case NetworkId.dirtRoad: return "DirtRoad";
    case NetworkId.groundHighway: return "Highway";
  }
}

/// Convert the string representation of a Network ID to its integer equivalent.
NetworkId transitType(string network) {
  switch (network) {
    case "Road": return NetworkId.road;
    case "Rail": return NetworkId.rail;
    case "ElevatedHighway": return NetworkId.elevatedHighway;
    case "Street": return NetworkId.street;
    case "Pipe": return NetworkId.pipe;
    case "PowerLine": return NetworkId.powerLine;
    case "Avenue": return NetworkId.avenue;
    case "Subway": return NetworkId.subway;
    case "LightRail": return NetworkId.lightRail;
    case "Monorail": return NetworkId.monorail;
    case "OneWayRoad": return NetworkId.oneWayRoad;
    case "DirtRoad": return NetworkId.dirtRoad;
    case "Highway": return NetworkId.groundHighway;
    default: assert(0, "");
  }
}

/// Implicitly converts to `bool`.
alias TransmogrifyFlag = std.typecons.Flag!"transmogrify";

///
struct RuleSet {
  ///
  NetworkId transitType;
  ///
  TransmogrifyFlag transmogrify;
  ///
  TileRule[] rules;

  ///
  this(NetworkId transitType, TileRule[] rules) {
    this.transitType = transitType;
    this.rules = rules;
  }
  ///
  this(TransmogrifyFlag transmogrify, TileRule[] rules) {
    this.transitType = NetworkId.undefined;
    this.transmogrify = transmogrify;
    this.rules = rules;
  }
}

///
enum Flag : ubyte {
  /// No connection.
  none = 0,
  /// Left at 45 degree angle, i.e. a diagonal connection
  diagonalLeft = 1,
  /// Straight connection.
  straight = 2,
  /// Right at 45 degree angle, i.e. a diagonal connection
  diagonalRight = 3,
  /// Shared median for 2 tile wide networks
  median = 4,

  /// Off center "blend" sloped connection for `diagonalLeft` becoming `straight`
  blendLeft = 11,
  /// Off center "blend" sloped connection for `diagonalRight` becoming `straight`
  blendRight = 13,

  /// Rail: Diagonal switch left
  railSwitchLeft = 21,
  /// Rail: Diagonal switch right
  railSwitchRight = 23,
  /// Rail: Secondary orthogonal blend-switch left
  railSwitchBlendLeft = 22,
  /// Rail: Secondary orthogonal blend-switch right
  railSwitchBlendRight = 42,
  /// Rail: Orthogonal-diagonal switch cross-over left
  railCrossOverLeft = 32,
  /// Rail: Orthogonal-diagonal switch cross-over right
  railCrossOverRight = 52,
  /// Rail: Wye
  railWye = 62,
  /// Rail: W-switch
  railSwitchW = 72,
}

/// Equivalent to a `uint` packing cardinal network flags, i.e. `0xSSEENNWW`
/// See_Also: <a href="https://wiki.sc4devotion.com/index.php?title=Network_Flags">Network Flags</a> (SC4D Encyclopedia)
struct NetworkFlag {
  version (D_Ddoc) {
    ///
    Flag south;
    ///
    Flag east;
    ///
    Flag north;
    ///
    Flag west;
  }

  import std.bitmanip : bitfields;
  mixin(bitfields!(
    ubyte, "south", 8,
    ubyte, "east", 8,
    ubyte, "north", 8,
    ubyte, "west", 8,
  ));
}

static assert(NetworkFlag.sizeof == 4);

///
enum Adjacency : ubyte {
  /// None, i.e. the central tile.
  none = 0,
  /// West
  west = 1,
  /// Northwest
  northwest = 2,
  /// North
  north = 3,
  /// Northeast
  northeast = 4,
  /// East
  east = 5,
  /// Southeast
  southeast = 6,
  /// South
  south = 7,
  /// Southwest
  southwest = 8,
  /// West, 2 tiles from center
  westX = 9,
  /// West-northwest, 2 tiles from center
  westNorthwestX = 10,
  /// Northwest, 2 tiles from center
  northwestX = 11,
  /// North-northwest, 2 tiles from center
  northNorthwestX = 12,
  /// North, 2 tiles from center
  northX = 13,
  /// North-northeast, 2 tiles from center
  northNortheastX = 14,
  /// Northeast, 2 tiles from center
  northeastX = 15,
  /// East-northeast, 2 tiles from center
  eastNortheastX = 16,
  /// East, 2 tiles from center
  eastX = 17,
  /// East-southeast, 2 tiles from center
  eastSoutheastX = 18,
  /// Southeast, 2 tiles from center
  southeastX = 19,
  /// South-southeast, 2 tiles from center
  southSoutheastX = 20,
  /// South, 2 tiles from center
  southX = 21,
  /// South-southwest, 2 tiles from center
  southSouthwestX = 22,
  /// Southwest, 2 tiles from center
  southwestX = 23,
  /// West-southwest, 2 tiles from center
  westSouthwestX = 24,
}

///
enum RuleType : ubyte {
  /// Central tile.
  tile = 1,
  ///
  neighbor = 2,
  /// FSH texture or S3D Exemplar.
  asset = 3
}

///
struct Rule {
  ///
  RuleType type;
  union {
    /// Central tile.
    NetworkFlag tile;
    struct {
      ///
      Adjacency relation;
      union {
        /// Central tile.
        NetworkFlag neighbor;
        struct {
          /// FSH or Exemplar Instance ID
          uint instanceId;
          /// Rotation, in degrees.
          int rotation;
          /// Whether to flip the texture.
          std.typecons.Flag!"flipped" flipped;
        }
      }
    }
  }
}

///
struct TileRule {
  /// Central tile.
  NetworkFlag tile;
  ///
  Rule[] rules;
}

/// Parse an individual network rule set.
/// See_Also: <a href="https://wiki.sc4devotion.com/index.php?title=Individual_Network_RULs">Individual Network Rules</a> (SC4D Encyclopedia)
auto rulParser() {
  import std.algorithm : all;
  import std.conv : parse, to;
  import std.string : replace;
  import std.typecons : No, Yes;

  NetworkFlag toNetworkFlag(Flag[] flags) {
    assert(flags.length == 4);
    assert(flags.all!((flag) {
      if (flag >= 0 && flag <= 4) return true;
      if (flag == 11) return true;
      if (flag == 13) return true;
      return false;
    }));

    NetworkFlag result;
    result.west = flags[0];
    result.north = flags[1];
    result.east = flags[2];
    result.south = flags[3];
    return result;
  }

  with(parsers!S) {
    auto comma = tk!',';
    auto newline = any(tk!'\r', tk!'\n', literal!"\r\n");
    auto number = range!('0', '9').rep.map!(x => x.to!uint);
    auto hexDigit = any(range!('A', 'F'), range!('a', 'f'), range!('0', '9'));
    auto hexNumber = seq(literal!"0x", hexDigit.rep!(1, 8)).map!(x => x[1]);
    auto transitType = any(range!('A', 'Z'), range!('a', 'z')).rep!4;

    auto header = any(
      seq(tk!'#', transitType, tk!'#').map!(x => x[1].replace("Rules", "").transitType),
      seq(tk!'#', literal!"Transmogrify").map!(_ => Yes.transmogrify)
    );
    auto comment = seq(tk!';', range!(32, 126).rep!0.skipWs).skipWs;
    auto cardinalFlag = number.skipWs.map!(x => x.to!Flag);
    auto centralTile = seq(
      tk!'1',
      seq(comma, cardinalFlag).map!(x => x[1]).array!(4, 4).map!(toNetworkFlag)
    ).map!((tokens) {
      Rule rule;
      rule.type = RuleType.tile;
      rule.tile = tokens[1];
      return rule;
    });
    auto adjacentTile = seq(
      tk!'2',
      seq(comma, number.skipWs).map!(x => x[1]),
      seq(comma, cardinalFlag).map!(x => x[1]).array!(4, 4).map!(toNetworkFlag)
    ).map!((tokens) {
      Rule rule;
      rule.type = RuleType.neighbor;
      rule.relation = tokens[1].to!Adjacency;
      rule.neighbor = tokens[2];
      return rule;
    });
    auto texture = seq(
      tk!'3',
      seq(comma, number.skipWs).map!(x => x[1]),
      // FSH or Exemplar Instance ID
      seq(comma, hexNumber.skipWs).map!(x => parse!uint(x[1], 16)),
      // Rotation, in degrees
      seq(comma, range!('0', '3').skipWs).map!(x => x[1].to!string.to!ubyte),
      // Whether to flip the texture
      seq(comma, range!('0', '1').skipWs).map!(x => x[1] == '1' ? true : false)
    ).map!((tokens) {
      Rule rule;
      rule.type = RuleType.asset;
      rule.relation = tokens[1].to!Adjacency;
      rule.instanceId = tokens[2];
      rule.rotation = tokens[3].to!int * 90;
      rule.flipped = tokens[4] ? Yes.flipped : No.flipped;
      return rule;
    });
    auto tileRule = seq(
      centralTile, newline,
      delimited(adjacentTile, newline),
      delimited(texture, newline),
    ).skipWs.map!((tokens) {
      auto tile = TileRule(tokens[0].tile, new Rule[tokens[2].length + tokens[3].length]);
      tile.rules ~= tokens[2];
      tile.rules ~= tokens[3];
      return tile;
    });

    return seq(
      header,
      any(comment, tileRule).array.map!((collection) {
        import std.algorithm : filter, map;
        import std.array : array;
        return collection.filter!(x => x.convertsTo!TileRule).map!(x => x.get!TileRule).array;
      })
    ).map!((tokens) {
      if (tokens[0].convertsTo!NetworkId) return RuleSet(tokens[0].get!NetworkId, tokens[1]);
      else return RuleSet(tokens[0].get!TransmogrifyFlag, tokens[1]);
    });
  }
}

version (unittest) import std.conv : text;

unittest {
  auto input = "#Transmogrify".stream;
  RuleSet rules;
  ParserError err;
  assert(!rulParser.parse(input, rules, err));
}

unittest {
  auto input = "#HighwayRules#\n1,13,2,0,2\n3,0,0x2001800,0,0".stream;
  RuleSet rules;
  ParserError err;
  assert(rulParser.parse(input, rules, err), err.text);
  assert(rules.transitType == NetworkId.highway);
}

unittest {
  auto input = "#RoadRules#\n1,13,2,0,2\n3,0,0x2001800,0,0".stream;
  RuleSet rules;
  ParserError err;
  assert(rulParser.parse(input, rules, err), err.text);
  assert(rules.transitType == NetworkId.road);
}

unittest {
  auto input = "#RailRules#\n1,13,2,0,2\n3,0,0x2001800,0,0".stream;
  RuleSet rules;
  ParserError err;
  assert(rulParser.parse(input, rules, err), err.text);
  assert(rules.transitType == NetworkId.rail);
}
