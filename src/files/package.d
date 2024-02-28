/// File formats used by <a href="https://www.wiki.sc4devotion.com/index.php?title=SimCity_4">SimCity 4</a>,
/// The Sims 2, Spore, etc.
///
/// Remarks:
/// These file types are generally found inside DBPF files (such as .dat files). Some of them, however, can be
/// freestanding files.
///
/// See_Also: $(UL
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=DBPF">DBPF</a> (SC4D Encyclopedia))
///   $(LI <a href="https://www.wiki.sc4devotion.com/index.php?title=List_of_File_Formats">List of File Formats</a> (SC4D Encyclopedia))
/// )
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2024 Chance Snow. All rights reserved.
/// License: MIT License
module dbpf.files;

import pry : SimpleStream;
import std.conv : castFrom, to;

package(dbpf) alias S = SimpleStream!string;
/// Parser error.
alias ParserError = S.Error;

package(dbpf) ubyte[] toBytes(T)(T value) {
  void* ptr = &value;
  return castFrom!(void[]).to!(ubyte[])(ptr[0..T.sizeof]);
}

package(dbpf) T read(T)(ubyte[] buffer) {
  if (!buffer.length) return T.init;
  assert(buffer.length >= T.sizeof);
  T[] value = buffer.ptr[0..T.sizeof].to!(T[]);
  return value[0];
}
