# Copied from: <https://gist.github.com/PatrickDaG/c075f5ef8a7cba59b0999d8a0dd7a7ce>
{ lib }:
let
  inherit (builtins) foldl' elemAt genList bitAnd;

  masksLut = foldl' (l: n: l ++ [ (2 * elemAt l n) ]) [ 1 ] (genList (x: x) 62);
  intMax = (-intMin) - 1;
  intMin = 9223372036854775807;

  bitShiftLeft = shift: bits:
    if shift >= 64 then
      0
    else if shift == 0 then
      bits
    else if shift < 0 then
      bitShiftRight (-shift) bits
    else
      let
        inv = 63 - shift;
        mask = if inv == 63 then intMin else (elemAt masksLut inv) - 1;
        masked = bitAnd bits mask;
        checker = if inv == 63 then intMax else elemAt masksLut inv;
        negate = bitAnd bits checker != 0;
        mult = if shift == 63 then intMax else elemAt masksLut shift;
        result = masked * mult;
      in if negate then intMax + result else result;

  bitShiftRight = shift: bits:
    if shift >= 64 then
      0
    else if shift == 0 then
      bits
    else if shift < 0 then
      bitShiftLeft (-shift) bits
    else
      let
        masked = bitAnd bits intMin;
        negate = bits < 0;
        result = masked / 2 / (elemAt masksLut (shift - 1));
        inv = 63 - shift;
        highestBit = elemAt masksLut inv;
      in if negate then result + highestBit else result;
in { # #
  inherit bitShiftLeft bitShiftRight;
}
