/// FSH and QFS compression functions.
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2024 Chance Snow. All rights reserved.
/// License: MIT License
/// See_Also: <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF_Compression">QFS Compression</a> (SC4D Encyclopedia)
module dbpf.compression;

import std.conv : to;
import qfs;

///
ubyte[] decompress(ubyte[] data) {
  import std.algorithm : copy;
  import std.conv : castFrom;

  int length = data.length.to!int;
  ubyte* resultPtr = uncompress_data(data.ptr, &length);
  // Make a copy of the uncompressed data in D-land
  auto result = new ubyte[castFrom!(ubyte*).to!(char*)(resultPtr).strlen];
  assert(resultPtr[0..result.length].copy(result).length == 0, "Uncompressed data was not fully copied!");
  resultPtr.free;

  return result;
}

///
ubyte[] compress(ubyte[] data) {
  int length = data.length.to!int;
  auto result = new ubyte[length * 2];
  // TODO: Pad input buffer with 1028 bytes
  compress_data(data.ptr, &length, result.ptr);
  // TODO: Trim null bytes from end of result?
  return result;
}
