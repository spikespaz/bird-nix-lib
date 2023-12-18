# bird-nix-lib

Useful functions I've made. It's not ready for a proper launch yet,
I need to get some kind of documentation generator.

Take a look at `lib/default.nix` to see what is available in `lib.lib`,
and `flake.nix` to see how to avoid using `lib.lib` (the proper way).

There are some comments, so take a look at the source. Most should be intuitive.

[
  These are the functions of the prelude
  (top-level attrs merged into Nixpkgs' `lib`).
](#prelude)

## Documentation

For now, there is source code and a map:

```sh
$ nix eval 'github:spikespaz/bird-nix-lib#lib.lib' --apply '(lib: lib.mapAttrsRecursive (_: lib.generators.toPretty {}) lib.bird)' | nix run 'github:serokell/nixfmt' -- | wl-copy
```

Which shows the contents of `lib.lib.bird` (or `lib.bird`), pasted here:

```nix
{
  collectTests = "<function>";
  evalTest = "<function, args: {expect, expr, name, path}>";
  getTestCoverage = "<function>";
  getTestResults = "<function>";
  importDir = "<function>";
  importDir' = "<function>";
  importDirRecursive = "<function>";
  importTests = "<function>";
  isTestSuite = "<function>";
  lib = {
    attrsets = {
      attrPaths = "<function>";
      hasAttrs = "<function>";
      hasExactAttrs = "<function>";
      mapListToAttrs = "<function>";
      mapRecursiveCond = "<function>";
      mapThruAttr = "<function>";
      recursiveUpdates = "<function>";
      thruAttr = "<function>";
      updates = "<function>";
    };
    debug = {
      traceM = "<function>";
      traceValM = "<function>";
    };
    encoding = {
      decodeBinary = "<function>";
      decodeBinary' = "<function>";
      encodeBinary = "<function>";
      encodeBinary' = "<function>";
      encodeBinaryBytes = "<function>";
      encodeBinaryBytes' = "<function>";
    };
    generators = {
      toTOML = "<function>";
      toTOMLFile = "<function>";
    };
    lists = {
      elemAt = "<function>";
      elemAtDefault = "<function>";
      flattenCond = "<function>";
      indexOf = "<function>";
      indexOfDefault = "<function>";
      indicesOf = "<function>";
      indicesOfPred = "<function>";
      lastIndexOf = "<function>";
      lastIndexOfDefault = "<function>";
      lpad = "<function>";
      lsplit = "<function>";
      removeElems = "<function>";
      rpad = "<function>";
      rsplit = "<function>";
      split = "<function>";
      sublist = "<function>";
    };
    math = {
      abs = "<function>";
      mantissa = "<function>";
      pow = "<function>";
      powi = "<function>";
      round = "<function>";
    };
    radix = { intToHex = "<function>"; };
    scaffold = {
      importDir = "<function>";
      importDir' = "<function>";
      importDirRecursive = "<function>";
      importDirRecursive' = "<function>";
      mkDirEntry = "<function>";
      mkHome = "<function, args: {inputs}>";
      mkHost = "<function, args: {inputs}>";
      mkJoinedOverlays = "<function>";
      mkUnfreeOverlay = "<function>";
      readDirEntries = "<function>";
      walkDir = "<function>";
      walkDir' = "<function>";
      walkDirRecursive = "<function>";
      walkDirRecursiveCond = "<function>";
    };
    shellscript = {
      wrapShellScript = "<function>";
      writeNuScript = "<function>";
      writeShellScriptShebang = "<function>";
    };
    sources = {
      defaultSourceFilter = "<function>";
      editorSourceFilter = "<function>";
      flakeSourceFilter = "<function>";
      mkSourceFilter = "<function>";
      objectSourceFilter = "<function>";
      rustSourceFilter = "<function>";
      sourceFilter = "<function>";
      unknownSourceFilter = "<function>";
      vcsSourceFilter = "<function>";
    };
    strings = {
      charAt = "<function>";
      charAtDefault = "<function>";
      endsWith = "<function>";
      indexOfChar = "<function>";
      indexOfCharDefault = "<function>";
      indicesOfChar = "<function>";
      lastIndexOfChar = "<function>";
      lastIndexOfCharDefault = "<function>";
      lpadString = "<function>";
      lsplitString = "<function>";
      lstrip = "<function>";
      removeChars = "<function>";
      rpadString = "<function>";
      rsplitString = "<function>";
      rstrip = "<function>";
      startsWith = "<function>";
      strip = "<function>";
      substring = "<function>";
      toPercent = "<function>";
      trim = "<function>";
    };
    tests = {
      collectTests = "<function>";
      evalTest = "<function, args: {expect, expr, name, path}>";
      getTestCoverage = "<function>";
      getTestResults = "<function>";
      importTests = "<function>";
      isTestSuite = "<function>";
      mkTestSuite = "<function>";
      runTestsRecursive = "<function>";
      showTestCoverage =
        "<function, args: {covered, missing, missingPaths, total}>";
      showTestResults = "<function, args: {failures, successes}>";
    };
    trivial = {
      applyArgs = "<function>";
      applyAutoArgs = "<function>";
      imply = "<function>";
      implyDefault = "<function>";
      nand = "<function>";
      nor = "<function>";
      not = "<function>";
      xnor = "<function>";
      xor = "<function>";
    };
    units = {
      bytes = {
        GB = "<function>";
        GiB = "<function>";
        KiB = "<function>";
        MB = "<function>";
        MiB = "<function>";
        PB = "<function>";
        PiB = "<function>";
        TB = "<function>";
        TiB = "<function>";
        kB = "<function>";
      };
      kbytes = {
        GB = "<function>";
        GiB = "<function>";
        MB = "<function>";
        MiB = "<function>";
        PB = "<function>";
        PiB = "<function>";
        TB = "<function>";
        TiB = "<function>";
      };
    };
  };
  mkHome = "<function, args: {inputs}>";
  mkHost = "<function, args: {inputs}>";
  mkJoinedOverlays = "<function>";
  mkTestSuite = "<function>";
  mkUnfreeOverlay = "<function>";
  prelude = {
    # ... extracted elsewhere
  };
  runTestsRecursive = "<function>";
  showTestCoverage =
    "<function, args: {covered, missing, missingPaths, total}>";
  showTestResults = "<function, args: {failures, successes}>";
}
```
## Prelude

```nix
{
  abs = "<function>";
  applyArgs = "<function>";
  applyAutoArgs = "<function>";
  attrPaths = "<function>";
  bytes = {
    GB = "<function>";
    GiB = "<function>";
    KiB = "<function>";
    MB = "<function>";
    MiB = "<function>";
    PB = "<function>";
    PiB = "<function>";
    TB = "<function>";
    TiB = "<function>";
    kB = "<function>";
  };
  charAt = "<function>";
  charAtDefault = "<function>";
  decodeBinary = "<function>";
  decodeBinary' = "<function>";
  defaultSourceFilter = "<function>";
  editorSourceFilter = "<function>";
  elemAtDefault = "<function>";
  encodeBinary = "<function>";
  encodeBinary' = "<function>";
  encodeBinaryBytes = "<function>";
  encodeBinaryBytes' = "<function>";
  endsWith = "<function>";
  flakeSourceFilter = "<function>";
  flattenCond = "<function>";
  hasAttrs = "<function>";
  hasExactAttrs = "<function>";
  imply = "<function>";
  implyDefault = "<function>";
  importDir = "<function>";
  importDir' = "<function>";
  importDirRecursive = "<function>";
  importDirRecursive' = "<function>";
  indexOf = "<function>";
  indexOfChar = "<function>";
  indexOfCharDefault = "<function>";
  indexOfDefault = "<function>";
  indicesOf = "<function>";
  indicesOfChar = "<function>";
  indicesOfPred = "<function>";
  intToHex = "<function>";
  kbytes = {
    GB = "<function>";
    GiB = "<function>";
    MB = "<function>";
    MiB = "<function>";
    PB = "<function>";
    PiB = "<function>";
    TB = "<function>";
    TiB = "<function>";
  };
  lastIndexOf = "<function>";
  lastIndexOfChar = "<function>";
  lastIndexOfCharDefault = "<function>";
  lastIndexOfDefault = "<function>";
  lpad = "<function>";
  lpadString = "<function>";
  lsplit = "<function>";
  lsplitString = "<function>";
  lstrip = "<function>";
  mantissa = "<function>";
  mapListToAttrs = "<function>";
  mapRecursiveCond = "<function>";
  mapThruAttr = "<function>";
  mkDirEntry = "<function>";
  mkSourceFilter = "<function>";
  nand = "<function>";
  nor = "<function>";
  not = "<function>";
  objectSourceFilter = "<function>";
  pow = "<function>";
  powi = "<function>";
  readDirEntries = "<function>";
  recursiveUpdates = "<function>";
  removeChars = "<function>";
  removeElems = "<function>";
  round = "<function>";
  rpad = "<function>";
  rpadString = "<function>";
  rsplit = "<function>";
  rsplitString = "<function>";
  rstrip = "<function>";
  rustSourceFilter = "<function>";
  sourceFilter = "<function>";
  split = "<function>";
  startsWith = "<function>";
  strip = "<function>";
  sublist = "<function>";
  thruAttr = "<function>";
  toPercent = "<function>";
  traceM = "<function>";
  traceValM = "<function>";
  trim = "<function>";
  unknownSourceFilter = "<function>";
  updates = "<function>";
  vcsSourceFilter = "<function>";
  walkDir = "<function>";
  walkDir' = "<function>";
  walkDirRecursive = "<function>";
  walkDirRecursiveCond = "<function>";
  wrapShellScript = "<function>";
  writeNuScript = "<function>";
  writeShellScriptShebang = "<function>";
  xnor = "<function>";
  xor = "<function>";
}
```
