final: prev:
let
  callLibs = file: import file { lib = final; };
  lib = {
    attrsets = callLibs ./attrsets.nix;
    builders = callLibs ./builders.nix;
    debug = callLibs ./debug.nix;
    # generators = callLibs ./generators.nix;
    lists = callLibs ./lists.nix;
    math = callLibs ./math.nix;
    strings = { inherit (lib.lists) indicesOf split lsplit rsplit; };
    shellscript = callLibs ./shellscript.nix;
    trivial = callLibs ./trivial.nix;
  };
  prelude = {
    inherit (lib.attrsets)
      updates recursiveUpdates deepMergeAttrs thruAttr mapThruAttr
      mapListToAttrs;
    inherit (lib.debug) traceM traceValM;
    inherit (lib.lists)
      indexOf indicesOf getElemAt removeElems sublist split lsplit rsplit;
    inherit (lib.math) pow powi;
    inherit (lib.shellscript)
      wrapShellScript writeShellScriptShebang writeNuScript;
    inherit (lib.trivial) imply implyDefault applyArgs;
  };
in prev // prelude // {
  birdos = {
    inherit lib prelude;
    inherit (lib.builders)
      mkFlakeTree mkFlakeSystems mkJoinedOverlays mkUnfreeOverlay mkHost mkHome;
  };
  maintainers.spikespaz = {
    email = "jacob@birkett.dev";
    github = "spikespaz";
    githubId = "MDQ6VXNlcjEyNTAyOTg4";
    name = 12502988;
  };
}
