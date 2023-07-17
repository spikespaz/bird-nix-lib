{ lib }:
let
  # Produces a hexadecimal RRGGBBAA color from an attributes.
  # Each channel value is expected to be between 0-255.
  # Alpha attribute `a` is not required and may be undefined or null.
  hexRGBA = { r, g, b, a ? null }:
    lib.concatStrings (map (c: lib.lpadString "0" 2 (lib.intToHex c))
      ([ r g b ] ++ lib.optional (a != null) a));

  # Like `hexRGBA` but takes alpha as float in a separate argument.
  hexRGBA' = rgb: a:
    let a' = builtins.floor (a * 255);
    in hexRGBA (rgb // { a = a'; });

  gruvbox = import ./palettes/gruvbox.nix { inherit lib; };
in {
  inherit hexRGBA hexRGBA';
  palettes = { inherit gruvbox; };
}
