{ lib }:
let
  # Encode an integer as a list of bits (integers of `0` or `1`).
  encodeBinary = n:
    let
      recurse = n:
        if n == 0 then [ ] else (recurse (n / 2)) ++ [ (lib.mod n 2) ];
    in if n == 0 then [ 0 ] else recurse n;

  encodeBinaryBytes = n:
    let
      bits = encodeBinary n;
      numTrail = lib.mod (lib.length bits) 8;
      padding = lib.replicate (8 - numTrail) 0;
    in if numTrail == 0 then bits else padding ++ bits;

  encodeBinaryBytes' = n: lib.reverseList (encodeBinaryBytes n);

  # Decode a little-endian list of bits (integers of `0` or `1`)
  # into an integer.
  decodeBinary = bits:
    (lib.foldr (bit:
      { int, place }: {
        int = place * bit + int;
        place = place * 2;
      }) {
        int = 0;
        place = 1;
      } bits).int;

  # # The big-endian version of `encodeBinary`.
  # The big-endian version of `decodeBinary`.
  decodeBinary' = bits: decodeBinary (lib.reverseList bits);
in { inherit encodeBinary encodeBinaryBytes encodeBinaryBytes' decodeBinary; }
