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

static import std.stdio;
import std.traits : isFloatingPoint;

/// Determines whether `V` is a valid DBPF version number.
/// See_Also: `Version`
/// Remarks: $(UL
///   $(LI `1.0` seen in SimCity 4, The Sims 2)
///   $(LI `1.1` seen in The Sims 2)
///   $(LI `2.0` seen in Spore, The Sims 3)
///   $(LI `3.0` seen in SimCity (2013))
/// )
enum isValidDbpfVersion(float V) = isFloatingPoint!(typeof(V)) && (V == 1 || V == 1.1 || V == 2 || V == 3);

/// Params:
/// V: DBPF archive version. See `Version`.
/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF#Header">DBPF Header</a> (SC4D Encyclopedia)
struct Header(float V = 1) if (isValidDbpfVersion!V) {
  import std.string : representation;

  /// Always `DBPF`.
  static const identifier = "DBPF".representation;
align(1):
  /// Always `DBPF`.
  ubyte[4] magic;
  ///
  Version version_;
  /// Unused, possibly reserved.
  uint unknown1;
  /// Unused, possibly reserved.
  uint unknown2;
  /// Should always be zero in DBPF v`2.0`.
  const uint unknown3 = 0;
  /// Date created. Unix timestamp.
  /// Remarks: Unused in DBPF `1.1`.
  uint dateCreated;
  /// Date modified. Unix timestamp.
  /// Remarks: Unused in DBPF v`1.1`.
  uint dateModified;
  /// Major version of the Index table.
  /// Remarks: Always `7` in The Sims 2 and SimCity 4. If this is a DBPF v`2.0` archive, then it is `0` for Spore.
  /// See_Also: `indexMinorVersion`
  uint indexMajorVersion = 0;
  /// Number of entries in the Index Table.
  uint indexEntryCount;
  static if (V < 2) {
    /// Offset to Index table, in bytes. Location of first index entry.
    uint indexOffset;
  } else private uint padding;
  /// Size of the Index table, in bytes.
  uint indexSize;
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
  static if (V >= 2) {
    /// Offset to Index table, in bytes. Location of first index entry.
    uint indexOffset;
  } else private uint padding;
  ///
  uint unknown4;
  /// Reserved for future use.
  ubyte[24] reserved;

  /// Computed, human-readable Index table version.
  Version indexVersion() const @property {
    static if (V >= 2) return Version(this.indexMajorVersion);
    else {
      const uint minor = this.indexMinorVersion == 0 ? 0 : this.indexMinorVersion - 1;
      return Version(this.indexMajorVersion, minor);
    }
  }
}

static assert(Header!(Version.sc4).alignof == 1);
static assert(Header!(Version.sc4).sizeof == 96);
static assert(Header!(Version.sims2).sizeof == 96);
static assert(Header!(Version.spore).sizeof == 96);
static assert(Header!(Version.simCity).sizeof == 96);

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
  /// ditto
  static const float sc4 = 1;
  ///
  static const float sims2 = 1.1;
  ///
  static const float spore = 2;
  ///
  static const float sims3 = 2;
  /// SimCity (2013)
  static const float simCity = 3;
align(1):
  ///
  uint major;
  ///
  uint minor;
}

static assert(Version.alignof == 1);
static assert(Version.sizeof == 8);

/// Determines whether `V` is a valid DBPF Index table version number.
/// See_Also: `Version`
enum isValidIndexVersion(float V) = isFloatingPoint!(typeof(V)) && (V == 0 || V == 7.0 || V == 7.1);

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
/// Index Tables list the contents of a DBPF package.
/// Remarks:
/// The index table is very similar to the directory file
/// (<a href="https://www.wiki.sc4devotion.com/index.php?title=DIR">DIR</a>) within a DPBF package. The difference
/// being that the Index Table lists every file in the package, whereas the directory file only lists the compressed
/// files within the package. <a href="https://www.wiki.sc4devotion.com/index.php?title=Reader">Reader</a> presents a
/// directory file that is a mashup of these two entities, listing every file in the package, as well as indicating
/// whether or not that particular file is compressed.
/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF#Index_Table">DBPF Index Table</a> (SC4D Encyclopedia)
struct Entry {
align(1):
  ///
  Tgi tgi;
  /// Location offset of a file in the archive, in bytes.
  uint offset;
  /// Size of a file, in bytes.
  uint size;
}
/// ditto
struct ResourceEntry {
align(1):
  ///
  Tgi tgi;
  /// Resource ID.
  uint resourceId;
  /// Location offset of a file in the archive, in bytes.
  uint offset;
  /// Size of a file, in bytes.
  uint size;
}

static assert(Entry.alignof == 1);
static assert(Entry.sizeof == 20);
static assert(ResourceEntry.alignof == 1);
static assert(ResourceEntry.sizeof == 24);

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

/// Occurs before `File.contents` only if the `File` is compressed.
struct FileHeader {
  import dbpf.types : int24;
align(1):
  /// Compressed size of the file, in bytes.
  uint compressedSize;
  /// Compression ID, i.e. (`0x10FB`). Always
  /// <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF_Compression">QFS Compression</a>.
  /// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF_Compression">DBPF Compression</a> (SC4D Encyclopedia)
  const ushort compressionId = 0x10FB;
  /// Uncompressed size of the file, in bytes.
  int24 uncompressedSize;
}

static assert(FileHeader.alignof == 1);
static assert(FileHeader.sizeof == 9);

import std.typecons : Flag;

/// Files fill the bulk of a DBPF archive.
///
/// A file header exists only if this file is compressed.
/// Remarks:
/// Each file is either uncompressed or compressed. To check if a file is compressed you first need to read the DIR
/// file, if it exists. If no <a href="https://www.wiki.sc4devotion.com/index.php?title=DIR">DIR</a> entry exists,
/// then no files within the package are compressed.
struct File(bool Compressed = Flag!"compressed" = false) {
  alias contents this;
  /// Exists only if this file is compressed.
  static if (Compressed) FileHeader header;

  /// Contents of this file.
  ///
  /// See <a href="https://www.wiki.sc4devotion.com/index.php?title=List_of_File_Formats">List of File Formats</a> for
  /// a list of the file types that may exist within a DBPF archive.
  ubyte[] contents;

  /// Uncompressed size of this file, in bytes.
  uint size() const @property {
    import std.conv : to;
    static if (Compressed) return this.header.uncompressedSize;
    else return this.contents.length.to!uint;
  }
}

/// Determines whether `DBPF and `V` are valid DBPF and Index table versions.
/// See_Also: $(UL
///   $(LI `isValidDbpfVersion`)
///   $(LI `isValidIndexVersion`)
///   $(LI `Version`)
/// )
enum isValidVersion(float DBPF, float V) = isValidDbpfVersion!DBPF && isValidIndexVersion!V;

///
struct Archive(float DBPF = 1, float V = 7.0) if (isValidVersion!(DBPF, V)) {
  alias Head = Header!DBPF;

  import std.exception : enforce;

  ///
  const string path;
  private std.stdio.File file;
  ///
  Head metadata;
  ///
  static if (V == 7.0) Entry[] entries;
  /// ditto
  static if (V == 7.1) ResourceEntry[] entries;

  /// Open a DBPF archive from the given file `path`.
  this(string path) {
    import std.algorithm : equal;
    import std.conv : parse, text, to;

    this.path = path;
    this.file = std.stdio.File(path, "rb");

    assert(this.file.size >= Head.sizeof);
    this.file.rawRead!Head((&metadata)[0..1]);
    enforce(metadata.magic[].equal(Head.identifier), "Input is not a DBPF archive.");
    // Ensure file version matches expectation
    debug const version_ = metadata.version_.major.text ~ "." ~ metadata.version_.minor.text;
    assert(
      parse!float(version_) == DBPF,
      "Mismatched DBPF version. Expected " ~ DBPF.text ~ ", but saw " ~ version_
    );
    // Ensure index version matches expectation
    assert(
      V == 7.1 ? metadata.indexMinorVersion == 2 : true,
      "Mismatched index version. Expected " ~ V.text ~ ", but saw " ~ metadata.indexMinorVersion.text
    );
    auto filesOffset = this.file.tell;

    this.file.seek(metadata.indexOffset);
    this.entries = new Table[metadata.indexEntryCount];
    this.file.rawRead!Table((entries.ptr)[0..entries.length]);

    this.file.seek(filesOffset);
  }

  ///
  void close() {
    file.close();
  }
}
