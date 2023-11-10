lib: lib0:
let
  inherit (import ./scaffold.nix { inherit lib; }) importDir;
  libAttrs =
    lib.mapAttrs (_: fn: fn { inherit lib; }) (importDir ./. "default.nix");

  prelude = {
    inherit (libAttrs.attrsets)
      updates hasAttrs hasExactAttrs recursiveUpdates mapRecursiveCond thruAttr
      mapThruAttr mapListToAttrs attrPaths;
    inherit (libAttrs.debug) traceM traceValM;
    # FIXME find a new name for `lib.lists.elemAt`, because `nixpkgs` uses
    # `with` on `lib` after `builtins` which makes it use this `elemAt`.
    inherit (libAttrs.lists)
      indicesOf indicesOfPred indexOfDefault indexOf lastIndexOfDefault
      lastIndexOf elemAtDefault removeElems sublist split lsplit rsplit lpad
      rpad flattenCond;
    inherit (libAttrs.math) pow powi mantissa round abs;
    inherit (libAttrs.sources)
      sourceFilter mkSourceFilter defaultSourceFilter unknownSourceFilter
      objectSourceFilter vcsSourceFilter editorSourceFilter flakeSourceFilter
      rustSourceFilter;
    # FIXME `substring` conflicts with `builtins.substring`.
    inherit (libAttrs.strings)
      indicesOfChar indexOfCharDefault indexOfChar lastIndexOfCharDefault
      lastIndexOfChar charAtDefault charAt removeChars lsplitString rsplitString
      lpadString rpadString strip lstrip rstrip trim startsWith endsWith
      toPercent;
    inherit (libAttrs.radix) intToHex;
    inherit (libAttrs.shellscript)
      wrapShellScript writeShellScriptShebang writeNuScript;
    inherit (libAttrs.trivial)
      not nand nor xor xnor imply implyDefault applyArgs applyAutoArgs;
    inherit (libAttrs.units) bytes kbytes;
    inherit (libAttrs.scaffold)
      importDir importDir' importDirRecursive mkDirEntry readDirEntries walkDir
      walkDir' walkDirRecursive walkDirRecursiveCond;
  };
in lib0 // prelude // {
  bird = {
    inherit prelude;
    lib = libAttrs;
    inherit (libAttrs.scaffold)
      importDir importDir' importDirRecursive mkFlakeSystems mkJoinedOverlays
      mkUnfreeOverlay mkHost mkHome;
    inherit (libAttrs.tests)
      evalTest getTestResults runTestsRecursive getTestCoverage showTestResults
      showTestCoverage mkTestSuite isTestSuite importTests collectTests;
  };

  maintainers.spikespaz = {
    email = "jacob@birkett.dev";
    github = "spikespaz";
    githubId = "MDQ6VXNlcjEyNTAyOTg4";
    name = 12502988;
  };
}
