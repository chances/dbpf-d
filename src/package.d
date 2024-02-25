/// Read and write Database Packed File (DBPF) archives.
///
/// See_Also: $(UL
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF">DBPF</a> (SC4D Encyclopedia))
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=List_of_File_Formats">List of File Formats</a> (SC4D Encyclopedia))
/// )
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2024 Chance Snow. All rights reserved.
/// License: MIT License
module dbpf;

import std.traits : isNumeric;

/// Determines whether `V` is a valid DBPF version number.
/// See_Also: `Version`
/// Remarks: $(UL
///   $(LI `1.0` seen in SimCity 4, The Sims 2)
///   $(LI `1.1` seen in The Sims 2)
///   $(LI `2.0` seen in Spore, The Sims 3)
///   $(LI `3.0` seen in SimCity (2013))
/// )
enum isValidVersion(V) = isNumeric!V && (V == 1 || V == 1.1 || V == 2 || V == 3);

///
struct Header(float V = 1) if (isValidVersion!V) {
  static const identifier = "DBPF";
  Version version_;
  static if (V >= 2) {
    /// Unused, possibly reserved.
    uint unknown1;
    /// Unused, possibly reserved.
    uint unknown2;
    /// Should always be zero in DBPF v`2.0`.
    const uint unknown3 = 0;
  }
  /// Date created. Unix timestamp.
  /// Remarks: Unused in DBPF `1.1`.
  uint dateCreated;
  /// Date modified. Unix timestamp.
  /// Remarks: Unused in DBPF v`1.1`.
  uint dateModified;
  /// Version of the index table.
  static if (V < 2) const uint majorVersion = 7;
  /// ditto
  else const uint majorVersion = 0;
  /// Number of entries in the Index Table.
  uint indexEntryCount;
  /// Location of first index entry.
  static if (V < 2) uint indexOffset;
  /// Size of the Index table, in bytes.
  uint indexSize;
  static if (V < 2) {
    /// Number of Hole entries in the Hole Record.
    uint holeEntryCount;
    /// Location of the hole Record.
    uint holeOffset;
    /// Size of the hole Record, in bytes.
    uint holeSize;
  }
  static if (V >= 2) {
    /// Offset to Index table, in bytes.
    uint indexOffset;
    ///
    uint unknown4;
  }
  /// Reserved for future use.
  char[24] reserved;
}

/// Remarks: $(UL
///   $(LI `1.0` seen in SimCity 4, The Sims 2)
///   $(LI `1.1` seen in The Sims 2)
///   $(LI `2.0` seen in Spore, The Sims 3)
///   $(LI `3.0` seen in SimCity(2013))
/// )
struct Version {
  ///
  static const float simCity4 = 1;
  ///
  static const float sims2 = 1.1;
  ///
  static const float spore = 2;
  ///
  static const float sims3 = 2;
  /// SimCity (2013)
  static const float simCity = 3;
  ///
  uint major;
  ///
  uint minor;
}
