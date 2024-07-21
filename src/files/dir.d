module dbpf.files.dir;

import dbpf : Version;

import std.typecons : Flag, No, Yes;

///
struct Entry(Flag!"isResource" isResource) {
  import dbpf.tgi : Tgi;
align(1):
  ///
  Tgi tgi;
  /// Resource ID.
  static if (isResource) uint resourceId;
  /// Size of an uncompressed file, in bytes.
  uint size;
}

static assert(Entry!(No.isResource).alignof == 1);
static assert(Entry!(No.isResource).sizeof == 16);
static assert(Entry!(Yes.isResource).alignof == 1);
static assert(Entry!(Yes.isResource).sizeof == 20);

///
struct Directory(Version indexVersion) {
  import dbpf : UncompressedFile;

  static if (indexVersion == Version.sc4Index) alias DirectoryEntry = Entry!(No.isResource);
  static if (indexVersion == Version.sc4Index) alias DirectoryEntry = Entry!(Yes.isResource);

  ///
  DirectoryEntry[] entries;

  ///
  this(ref UncompressedFile file) {
    import std.algorithm : copy;
    import std.conv : castFrom;

    this.entries = new DirectoryEntry[file.size / DirectoryEntry.sizeof];
    auto entriesBytes = castFrom!(DirectoryEntry*).to!(ubyte*)(entries.ptr);
    assert(file.contents.copy(entriesBytes[0..(entries.length * DirectoryEntry.sizeof)]).length == 0, "");
  }
}
