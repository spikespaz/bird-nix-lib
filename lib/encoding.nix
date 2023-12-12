{ lib }:
let
  # Encode an integer as a list of bits (integers of `0` or `1`).
  # The result is little-endian.
  encodeBinary = n:
    if n == 0 then [ ] else [ (lib.mod n 2) ] ++ (encodeBinary (n / 2));

  # Decode a little-endian list of bits (integers of `0` or `1`)
  # into an integer.
  decodeBinary = bits:
    (lib.foldl' ({ n, place }:
      bit: {
        n = place * bit + n;
        place = place * 2;
      }) {
        n = 0;
        place = 1;
      } bits).n;
in { inherit encodeBinary decodeBinary; }
