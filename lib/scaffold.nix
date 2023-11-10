{ lib }:
let
  inherit (lib) types;

  # Takes a directory and a deny clause, and imports each file or directory
  # based on rules. An attribute set of the imported expressions is returned,
  # named according to each file with the `.nix` suffix removed.
  #
  # Your deny clause is turned into a predicate.
  # See the type checking in source.
  #
  # The rules for importing are:
  #  1. Is a regular file ending with `.nix`.
  #  2. Is a directory containing the regular file `default.nix`.
  #  3. Your predicate, given `name` and `type`, returns `true`.
  importDir = path: keep:
    let
      inherit (lib) types;
      pred = # #
        if keep == null then
          (_: _: true)
        else if types.singleLineStr.check keep then
        # A single string is assumed to be a file name to be excluded.
          (name: type: !(type == "regular" && name == keep))
        else if lib.isFunction keep then
        # Basic predicate.
          keep
        else if (types.listOf types.singleLineStr).check keep then
        # A list of strings is assumed to be files
        # and directory names to exclude.
          (name: type: !(builtins.elem name keep))
        else if (types.listOf types.function).check keep then
        # Multiple predicates in a list, join them.
          (name: type: lib.bird.mkJoinedOverlays keep)
        else
          throw
          "importDir predicate should be a string, function, or list of strings or functions";
      isNix = name: type:
        (type == "regular" && lib.hasSuffix ".nix" name)
        || (lib.pathIsRegularFile "${path}/${name}/default.nix");
      pred' = name: type: (isNix name type) && (pred name type);
    in lib.pipe path [
      builtins.readDir
      (lib.filterAttrs pred')
      (lib.mapAttrs' (name: _: {
        name = lib.removeSuffix ".nix" name;
        value = import "${path}/${name}";
      }))
    ];

  mkDirEntry = dirName: name: type:
    let
      _atRoot = path: builtins.match "^/[^/]*/?$" path != null;
      _hasPrefix = lib.hasPrefix (toString dirName) name;
      _extMatch = builtins.match "^.*(\\..+)$" name;
    in rec {
      inherit name type;
      path = "${pathPrefix}/${baseName}";
      exists = builtins.pathExists path;
      baseName = baseNameOf name;
      pathPrefix = toString dirName;
      relPath = if _hasPrefix then lib.removePrefix pathPrefix name else name;
      atRoot = _atRoot relPath;
      extension =
        if _extMatch != null then builtins.elemAt _extMatch 0 else null;
      isHidden = lib.hasPrefix "." baseName;
      isLink = type == "symlink";
      isFile = type == "regular";
      isDir = type == "directory";
      isProject = !isHidden && (isFile || isDir);
      isNixFile = isFile && lib.hasSuffix ".nix" baseName;
      isDefault = isFile && baseName == "default.nix";
      hasDefault = isDir && lib.pathIsRegularFile "${path}/default.nix";
      hasNixFiles =
        let ls = lib.mapAttrsToList (mkDirEntry path) (builtins.readDir path);
        in exists && isDir
        && (builtins.any (it: it.isNixFile || (it.isDir && it.hasNixFiles)) ls);
      isNix = isProject && (isNixFile || (isDir && hasNixFiles));
    };

  readDirEntries = dir:
    lib.mapAttrsToList (mkDirEntry dir) (builtins.readDir dir);

  # Read `dir` to directory entries,
  # filter out entries by the `filter` predicate, and then apply `op` to each.
  walkDir = dir: filter: op:
    lib.pipe dir [
      readDirEntries
      (builtins.filter filter)
      (lib.mapListToAttrs (it: {
        name = it.name;
        value = op it;
      }))
    ];

  # Like `walkDir` but `rename` both filters and renames attrs.
  # If `rename` returns `null` for an entry, it is filtered out.
  # If a string is returned, that is the attribute name.
  walkDir' = dir: rename: op:
    lib.pipe dir [
      readDirEntries
      (builtins.filter (it: rename it != null))
      (lib.mapListToAttrs (it: {
        name = rename it;
        value = op it;
      }))
    ];

  walkDirRecursive = dir: rename: op:
    walkDir' dir rename
    (it: if it.isDir then walkDirRecursive it.path rename op else op it);

  # Like `walkDirsRecursive` but with an additional `cond` predicate that
  # chooses when to recurse a given entry.
  walkDirRecursiveCond = dir: cond: rename: op:
    walkDir' dir rename (it:
      if it.isDir && cond it then
        walkDirRecursiveCond it.path rename op
      else
        op it);

  importDir' = path: keep: importDirRecursive path keep false;

  _elaborateImportFilter = filter:
    if filter == null then
    # The default is to keep it if it has any Nix.
      (it: it.isNix)
    else if lib.isFunction filter then
    # If the `pred` is already a function leave it alone.
      filter
    else if types.singleLineStr.check filter then
    # A single string is an entry name to be excluded.
      ({ name, isNix, ... }: isNix && name != filter)
    else if (types.listOf types.singleLineStr).check filter then
    # A list of strings is a list of names to exclude.
      ({ name, isNix, ... }: isNix && !(builtins.elem name filter))
    else if (types.listOf types.function).check filter then
    # Each function in a list is folded, applied, and compounded with AND.
      (it: lib.foldl' (pass: fn: pass && fn it) it.isNix filter)
    else
      throw
      "pred can only be elaborated from null, string, list of string, function, or list of function";

  _elaborateRecurseFilter = filter:
    if lib.isBool filter then
    # The default is to recurse on directories of Nix files.
      (it: filter && it.hasNixFiles)
    else if lib.isFunction filter then
    # Leave existing functions alone.
      filter
    else if (types.listOf types.function).check filter then
    # Each function in a list is folded, applied, and compounded with AND.
      (it: lib.foldl' (pass: fn: pass && fn it) true filter)
    else
      throw "recurse can only be a boolean or a direntry filter";

  importDirRecursive = dir: keep: recurse:
    let
      # Predicate that determines if an importable entry should be kept.
      keep' = _elaborateImportFilter keep;
      # Predicate that determines if an entry should be recursed.
      recurse' = _elaborateRecurseFilter recurse;

    in lib.pipe (builtins.readDir dir) [
      (lib.mapAttrsToList (lib.mkDirEntry dir))
      (builtins.filter (it: keep' it || recurse' it))
      (map (it: {
        name =
          if it.isNixFile then lib.removeSuffix ".nix" it.name else it.name;
        value = # #
          if it.hasNixFiles && recurse' it then
            importDirRecursive it.path keep' recurse'
          else if it.isNixFile || it.hasDefault then
            import it.path
          else
            abort "unfiltered direntry: ${lib.generators.toPretty { } it}";
      }))
      builtins.listToAttrs
    ];

  mkFlakeSystems = matrix:
    lib.pipe matrix [
      (map (lib.applyArgs lib.intersectLists))
      lib.concatLists
    ];

  mkJoinedOverlays = overlays: pkgs: pkgs0:
    lib.foldl' (attrs: overlay: attrs // (overlay pkgs pkgs0)) { } overlays;

  mkUnfreeOverlay = pkgs: pkgs0:
    lib.pipe pkgs0 [
      (map (path: {
        inherit path;
        value = lib.getAttrFromPath path pkgs;
      }))
      (map (it:
        lib.setAttrByPath it.path (it.value.overrideAttrs (self: super:
          lib.recursiveUpdate super {
            meta.license = if builtins.isList super.meta.license then
              map (_: { free = true; }) super.meta.license
            else {
              free = true;
            };
          }))))
      (lib.foldl' lib.recursiveUpdate { })
    ];

  mkHost = args@{ inputs, ... }:
    setup@{
    # The platform on which packages will be run (built for).
    # Will be used as the default platform for the other two settings.
    # Will also be used for `targetPlatform`.
    hostPlatform,
    # The platform on which to build packages.
    # This is different from `localPlatform`.
    buildPlatform ? hostPlatform,
    # The input of nixpkgs to use for the host.
    nixpkgs ? inputs.nixpkgs,
    # Arguments to be given to nixpkgs instantiation.
    # <https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/impure.nix>
    nixpkgsArgs ? { }, overlays ? [ ],
    # Additional `specialArgs` (overwrites `args` attributes).
    specialArgs ? { },
    # Most component modules to merge.
    modules ? [ ],
    # additional arguments are passed through
    ... }:

    let
      ownArgs = builtins.attrNames (builtins.functionArgs (mkHost args));
      pkgs = import nixpkgs ({
        inherit overlays;
        localSystem = buildPlatform;
        # This does not work due to a litany of problems with platform comparisons
        # <https://github.com/NixOS/nixpkgs/pull/237512>
        # <https://github.com/NixOS/nixpkgs/pull/238136>
        # <https://github.com/NixOS/nixpkgs/pull/238331>
        # crossSystem = hostPlatform;
      } // (lib.optionalAttrs (!lib.systems.equals hostPlatform buildPlatform) {
        crossSystem = hostPlatform;
      }) // nixpkgsArgs);
    in nixpkgs.lib.nixosSystem ((removeAttrs setup ownArgs) // {
      modules = [{ nixpkgs.pkgs = pkgs; }] ++ modules;
      specialArgs = args // specialArgs // { inherit nixpkgs; };
    });

  mkHome = args@{ inputs, ... }:
    setup@{
    # The platform on which packages will be run (built for).
    # Will be used as the default platform for the other two settings.
    # Will also be used for `targetPlatform`.
    hostPlatform,
    # The platform on which to build packages.
    # This is different from `localPlatform`.
    buildPlatform ? hostPlatform,
    # the branch of nixpkgs to use for the environment
    nixpkgs ? inputs.nixpkgs,
    # arguments to be given to
    # <https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/impure.nix>
    nixpkgsArgs ? { }, overlays ? [ ],
    # home manager flake
    homeManager ? inputs.home-manager,
    # additional specialArgs (overwrites args attrs)
    extraSpecialArgs ? { },
    # host component modules
    modules ? [ ],
    # additional arguments are passed through
    ... }:
    let
      ownArgs = builtins.attrNames (builtins.functionArgs (mkHome args));
      lib = (args.lib or nixpkgs.lib).extend (self: super: {
        hm = import "${homeManager}/modules/lib" { lib = self; };
      });
    in homeManager.lib.homeManagerConfiguration ((removeAttrs setup ownArgs)
      // {
        inherit modules;
        pkgs = import nixpkgs ({
          inherit overlays;
          localSystem = buildPlatform;
          crossSystem = hostPlatform;
        } // nixpkgsArgs);
        extraSpecialArgs = args // extraSpecialArgs // { inherit nixpkgs lib; };
      });
in {
  #
  inherit importDir mkDirEntry readDirEntries walkDir walkDir' walkDirRecursive
    walkDirRecursiveCond importDir' importDirRecursive mkFlakeSystems
    mkJoinedOverlays mkUnfreeOverlay mkHost mkHome;
}
