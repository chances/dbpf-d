/// Authors: Chance Snow
/// Copyright: Copyright © 2024 Chance Snow. All rights reserved.
/// License: MIT License
module dbpf.types;

/// A 24-bit signed integer.
/// See_Also: <a href="https://forum.dlang.org/thread/sarwanlrindyawtztlgh@forum.dlang.org"24-bit int</a> (D Forum)
struct int24 {
align(1):
  private ubyte[3] payload;
  alias value this;

  this(int x) {
    value = x;
  }

  @property int value() {
    int val = *cast(int*)&payload & 0xFFFFFF;
    if (val & 0x800000)
      val |= 0xFF000000;
    return val;
  }

  @property int value(int x) {
    version(BigEndian) _payload = (cast(ubyte*)&x)[1..4];
    else payload = (cast(ubyte*)&x)[0 .. 3];
    return value;
  }

  auto opUnary(string op)() {
    static if (op == "++")
      value = value + 1;
    else static if (op == "--")
      value = value - 1;
    else static if (op == "+")
      return value;
    else static if (op == "-")
      return -value;
    else static if (op == "~")
      return ~value;
    else
      static assert(0, "Unary operator '" ~ op ~ "' is not supported by `int24`.");
  }

  auto opOpAssign(string op)(int x) {
    static const error = "Binary operator '" ~ op ~ "' is not supported by `int24`.";
    static assert(__traits(compiles, { mixin("value = value " ~ op ~ " x;"); }), error);

    mixin("value = value " ~ op ~ " x;");
    return this;
  }
}

static assert(int24.sizeof == 3);
static assert(int24.alignof == 1);

unittest {
  int24[3] a;
  assert(a.sizeof == 9);

  // Max value
  a[1] = 8_388_607;
  assert(a[1] == 8_388_607);
  // Test for buffer overflow:
  assert(a[0] == 0);
  assert(a[2] == 0);

  // Overflow
  a[1] = 8_388_608;
  assert(a[1] == -8_388_608);
  // Test for buffer overflow:
  assert(a[0] == 0);
  assert(a[2] == 0);

  // Negative value
  a[1] = -1;
  assert(a[1] == -1);
  // Test for buffer overflow:
  assert(a[0] == 0);
  assert(a[2] == 0);

  // Unary operators
  a[1] = 0;
  assert(~a[1] == -1);
  a[1]--;
  assert(a[1] == -1);
  assert(-a[1] == 1);
  assert(+a[1] == -1);
  a[1]++;
  assert(a[1] == 0);

  // Binary operators
  a[1] = 0;
  a[1] = a[1] + 1;
  assert(a[1] == 1);
  a[1] += 1;
  assert(a[1] == 2);
  a[1] = a[1] - 1;
  assert(a[1] == 1);
  a[1] -= 1;
  assert(a[1] == 0);

  a[1] = 3;
  a[1] = a[1] * 2;
  assert(a[1] == 6);
  a[1] = a[1] / 2;
  assert(a[1] == 3);
  a[1] *= 2;
  assert(a[1] == 6);
  a[1] /= 2;
  assert(a[1] == 3);
  a[1] = a[1] << 1;
  assert(a[1] == 6);
  a[1] <<= 1;
  assert(a[1] == 12);
  a[1] = a[1] >> 1;
  assert(a[1] == 6);
  a[1] >>= 1;
  assert(a[1] == 3);

  a[1] |= 4;
  assert(a[1] == 7);
  a[1] &= 5;
  assert(a[1] == 5);
  a[1] = a[1] | 2;
  assert(a[1] == 7);
  a[1] = a[1] & 3;
  assert(a[1] == 3);
}
