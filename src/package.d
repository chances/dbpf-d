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

import std.traits : isFloatingPoint;

/// Determines whether `V` is a valid DBPF version number.
/// See_Also: `Version`
/// Remarks: $(UL
///   $(LI `1.0` seen in SimCity 4, The Sims 2)
///   $(LI `1.1` seen in The Sims 2)
///   $(LI `2.0` seen in Spore, The Sims 3)
///   $(LI `3.0` seen in SimCity (2013))
/// )
enum isValidDbpfVersion(V) = isFloatingPoint!V && (V == 1 || V == 1.1 || V == 2 || V == 3);

/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF#Header">DBPF Header</a> (SC4D Encyclopedia)
struct Header(float V = 1) if (isValidDbpfVersion!V) {
  ///
  static const identifier = "DBPF";
  ///
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
  /// Major version of the Index table.
  /// Remarks: Always `7` in The Sims 2 and SimCity 4. If this is a DBPF v`2.0` archive, then it is `0` for Spore.
  /// See_Also: `indexMinorVersion`
  static if (V < 2) const uint indexMajorVersion = 7;
  /// ditto
  else const uint indexMajorVersion = 0;
  /// Number of entries in the Index Table.
  uint indexEntryCount;
  /// Offset to Index table, in bytes. Location of first index entry.
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
    /// Minor version of the Index table.
    /// Remarks:
    /// $(P In The Sims 2 for DBPF v`1.1+`.)
    /// $(P In DBPF >= v`2.0`, this is `3`, otherwise:)
    /// $(UL
    ///   $(LI `1` = v`7.0`)
    ///   $(LI `2` = v`7.1`)
    /// )
    /// See_Also: `indexMajorVersion`
    uint indexMinorVersion;
  }
  static if (V >= 2) {
    /// Offset to Index table, in bytes. Location of first index entry.
    uint indexOffset;
    ///
    uint unknown4;
  }
  /// Reserved for future use.
  char[24] reserved;

  /// Computed, human-readable Index table version.
  Version indexVersion() const @property {
    static if (V < 2) return Version(this.indexMajorVersion);
    else {
      uint minor = this.indexMinorVersion == 0 ? 0 : this.indexMinorVersion - 1;
      return Version(this.indexMajorVersion, minor);
    }
  }
}

/// Remarks: For DBPF version specifiers:
/// $(UL
///   $(LI `1.0` seen in SimCity 4, The Sims 2)
///   $(LI `1.1` seen in The Sims 2)
///   $(LI `2.0` seen in Spore, The Sims 3)
///   $(LI `3.0` seen in SimCity(2013))
/// )
/// For DBPF Index table version specifiers:
/// $(UL
///   $(LI `7.0` seen in SimCity 4, The Sims 2)
///   $(LI `7.1` seen in The Sims 2)
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

/// Determines whether `V` is a valid DBPF Index table version number.
/// See_Also: `Version`
enum isValidIndexVersion(V) = isFloatingPoint!V && (V == 0 || V == 7.0 || V == 7.1);

/// Index Tables list the contents of a DBPF package.
/// Remarks:
/// The index table is very similar to the directory file
/// (<a href="https://www.wiki.sc4devotion.com/index.php?title=DIR">DIR</a>) within a DPBF package. The difference
/// being that the Index Table lists every file in the package, whereas the directory file only lists the compressed
/// files within the package. <a href="https://www.wiki.sc4devotion.com/index.php?title=Reader">Reader</a> presents a
/// directory file that is a mashup of these two entities, listing every file in the package, as well as indicating
/// whether or not that particular file is compressed.
/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF#Index_Table">DBPF Index Table</a> (SC4D Encyclopedia)
struct IndexTable(float DBPF = 1, float V = 7.0) if (isValidDbpfVersion!DBPF && isValidIndexVersion!V) {
  /// Type ID.
  uint typeId;
  /// Group ID.
  uint groupId;
  /// Instance ID.
  uint instanceId;
  /// Resource ID.
  static if (V >= 7.1) uint resourceId;
  /// Location offset of a file in the archive, in bytes.
  uint offset;
  /// Size of a file, in bytes.
  uint size;
}

/// A Hole Table contains the location and size of all holes in a DBPF file.
/// Remarks:
/// Holes are created when the game deletes something from a DBPF. The holes themselves are simply junk data of the
/// appropriate length to fill the hole.
struct HoleTable {
  /// Location offset, in bytes.
  uint location;
  /// Size, in bytes.
  uint size;
}

/// Files fill the bulk of a DBPF archive.
///
/// A file header exists only if this file is compressed.
/// Remarks:
/// Each file is either uncompressed or compressed. To check if a file is compressed you first need to read the DIR
/// file, if it exists. If no <a href="https://www.wiki.sc4devotion.com/index.php?title=DIR">DIR</a> entry exists,
/// then no files within the package are compressed.
struct File(bool Compressed = Flag!"compressed" = false, size_t size) {
  alias header this;
  /// Exists only if this file is compressed.
  static if (Compressed) FileHeader header;
  /// Contents of this file.
  ubyte[size] contents;
}

/// Occurs before `File.contents` only if the `File` is compressed.
struct FileHeader {
  /// Compressed size of the file, in bytes.
  uint compressedSize;
  /// Compression ID, i.e. (`0x10FB`). Always
  /// <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF_Compression">QFS Compression</a>.
  /// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF_Compression">DBPF Compression</a> (SC4D Encyclopedia)
  const ushort compressionId = 0x10FB;
  /// Uncompressed size of the file, in bytes.
  ubyte[3] uncompressedSize;
}
