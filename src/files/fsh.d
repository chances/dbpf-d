/// Franks PC Shapes (Textures)
///
/// See_Also: $(UL
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH">Franks PC Shapes</a> (SC4D Encyclopedia))
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH_Format">FSH Format</a> (SC4D Encyclopedia))
/// )
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2024 Chance Snow. All rights reserved.
/// License: MIT License
module dbpf.files.fsh;

import std.conv : to;
import std.exception : enforce;
import std.string : representation;

///
enum DirectoryId {
  /// Building textures
  building = "G354".representation,
  /// Network textures, Sim textures, Sim heads, Sim animations, Trees, props, Base textures, Misc. colors
  generic = "G264".representation,
  /// 3D Animation textures (e.g. the green rotating diamond in `loteditor.dat`)
  _3dAnimation = "G266".representation,
  /// Dispatch marker textures
  dispatch = "G290".representation,
  /// Small Sim texture, Network Transport Model textures (trains, etc.)
  simThumbOrNetworkModel = "G315".representation,
  /// UI Editor textures
  ui = "GIMX".representation,
  /// BAT generator texture maps
  bat = "G344".representation,
}

///
struct Header {
  /// Always `SHPI`.
  static const identifier = "SHPI".representation;
align(1):
  /// Always `SHPI`.
  ubyte[4] magic = identifier.to!(ubyte[4]);
  ///
  uint size;
  ///
  uint entryCount;
  /// See_Also: `DirectoryId`
  uint directoryId;
}

static assert(Header.alignof == 1);
static assert(Header.sizeof == 16);

///
enum EntryName {
  /// Global palette for 8-bit Indexed Bitmaps.
  palette = "!pal".representation,
  /// Buildings, props, network intersections, and terrain textures.
  zero = "0000".representation,
  /// Always used for a rail texture, whereas for street/road intersections it's always by instance.
  rail = "rail".representation,
  /// First sprite animation entry in a directory.
  tb2 = "TB2".representation,
  /// Any sprite animation entries in a directory after TB2.
  tb3 = "TB3".representation,
}

///
struct Directory {
  import dbpf.types : str;
align(1):
  /// Remarks:
  /// When searching for a global palette for 8-bit bitmaps, the directory entry name for the global palette will
  /// always '!pal'. Once the '!pal' directory entry has been found, the global palette can be extracted and used for
  /// any bitmaps that use 8-bit indexed color. If no global palette is found, FSH decoders should look for a local
  /// palette directly following the indexed bitmap. If no palette is found, then no palette will be created or
  /// associated with the bitmap.
  ///
  /// Most tools, like FSHTool, simply ignore missing palettes and save the bitmap with an empty palette with all
  /// indices set to black.
  /// See_Also: `EntryName`
  str!4 entryName;
  /// Offset of the entry in the FSH file, in bytes.
  uint offset;
}

static assert(Directory.alignof == 1);
static assert(Directory.sizeof == 8);

/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH_Format#FSH_Entry_Header">FSH Entry Header</a> (SC4D Encyclopedia)
struct EntryHeader {
  import dbpf.types : int24;

align(1):
  /// Record ID
  ///
  /// Logically `AND`ed by `0x7f` for bitmap code or `0x80` to check if the entry is QFS compressed (unused by SC4).
  ubyte recordId;
  /// Size of an entry including this header.
  ///
  /// Only used if the file contains an attachment or embedded mipmaps. It is zero otherwise.
  /// Remarks:
  /// $(P For single images this is usually: `width x height + 0x10h`.)
  /// $(P
  ///   For images with embedded mipmaps, this is the total size of the original image, plus all mipmaps, plus the
  ///   header.
  /// )
  /// $(P In either case, it may include additional data as a binary attachment with unknown format.)
  int24 size;
  ///
  ushort width;
  ///
  ushort height;
  ///
  ushort centerX;
  ///
  ushort centerY;
  ///
  ushort positionX;
  ///
  ushort positionY;
}

static assert(EntryHeader.alignof == 1);
static assert(EntryHeader.sizeof == 16);

import std.typecons : Tuple;
/// A tuple of an entry's header and its data.
/// `data` is either palette or bitmap data.
/// Remarks:
/// After an entry's `header` is its bitmap, palette, or pixel color data.
///Authors:
/// Palettes are generally arrays of 256 colors, each 1 byte. Bitmaps may store their pixel data in one of many ways,
/// either raw bitmap pixel data, or they can make use of Microsoft DXTC compressed formats.
/// See_Also: $(UL
///   $(LI `EntryHeader`)
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH_Format#Bitmap_or_Palette_Data">Bitmap data</a> (SC4D Encyclopedia))
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH_Format#FSH_Entry_Header">FSH Entry Header</a> (SC4D Encyclopedia))
/// )
alias Entry = Tuple!(EntryHeader, "header", ubyte[], "data");

/// FSH images can store their pixel data raw, or they can make use of Microsoft DXTC compressed formats.
/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH_Format#Bitmap_or_Palette_Data">Bitmap data</a> (SC4D Encyclopedia)
enum BitmapType : ushort {
  /// 8-bit indexed
  ///
  /// Directly follows bitmap or uses global palette.
  indexed = 0x7B,
  /// 32-bit A8R8G8B8
  a8r8g8b8 = 0x7D,
  /// 24-bit A0R8G8B8
  a0r8g8b8 = 0x7F,
  /// 16-bit A1R5G5B5
  a1r5g5b5 = 0x7E,
  /// 16-bit A0R5G6B5
  a0r5g6b5 = 0x78,
  /// 16-bit A4R4G4B4
  a4r4g4b4 = 0x6D,
  /// DXT3 4x4 packed, 4-bit alpha
  ///
  /// 4x4 grid compressed, half-byte per pixel
  dxt3 = 0x61,
  /// DXT1 4x4 packed, 1-bit alpha
  ///
  /// 4x4 grid compressed, half-byte per pixel
  dxt1 = 0x60
}

/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH_Format#Bitmap_or_Palette_Data">Palette codes</a> (SC4D Encyclopedia)
enum Palette : ushort {
  /// 24-bit DOS
  dos = 0x22,
  /// 24-bit
  _24bit = 0x24,
  /// 16-bit NFS5
  nfs5 = 0x29,
  /// 32-bit
  _32bit = 0x2A,
  /// 16-bit
  _16bit = 0x2D,
}

/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH_Format#Bitmap_or_Palette_Data">Text codes</a> (SC4D Encyclopedia)
enum Text : ushort {
  /// Standard Text file
  text = 0x6F,
  /// ETXT of arbitrary length with full entry header
  etxt = 0x69,
  /// ETXT of 16 bytes or less including the header
  etxt16 = 0x70,
  /// Defined Pixel region hot-spot data for image
  hotspot = 0x7C,
}

/// A FSH document.
/// See_Also: $(UL
///   $(LI `Header`)
///   $(LI `Directory`)
///   $(LI `Entry`)
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH">Franks PC Shapes</a> (SC4D Encyclopedia))
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=FSH_Format">FSH Format</a> (SC4D Encyclopedia))
/// )
alias Fsh = Tuple!(Header, "header", Directory[], "directories", Entry[], "entries");

///
Fsh read(ubyte[] file) {
  import dbpf.files : read;
  import std.algorithm : startsWith;
  import std.conv : castFrom, to;
  import std.typecons : tuple;

  enforce(file.startsWith(Header.identifier), "Input is not a FSH document.");
  auto header = file.read!Header();
  // TODO: Read bitmap entries

  Fsh result = tuple(
    header,
    castFrom!(void[]).to!(Directory[])([]),
    castFrom!(void[]).to!(Entry[])([]),
  );
  return result;
}

///
ubyte[] write(Fsh document) {
  import dbpf.files : toBytes;
  import std.algorithm : copy, map, sum;

  auto buffer = new ubyte[
    Header.sizeof +
    (Directory.sizeof * document.directories.length) +
    (EntryHeader.sizeof * document.entries.length) +
    document.entries.map!(entry => EntryHeader.sizeof + entry.header.size.value).sum
  ];

  document.header.toBytes.copy(buffer[0..Header.sizeof]);
  // TODO: Write bitmap entries to the buffer

  return buffer;
}
