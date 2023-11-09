{ lib }:
let
  # Take a list of attribute sets, flatly updating them all into one.
  updates = builtins.foldl' (a: b: a // b) { };

  hasAttrs = names: attrs: lib.all (name: lib.hasAttr name attrs) names;

  hasExactAttrs = names: attrs:
    lib.length names == lib.length (lib.attrNames attrs)
    && lib.hasAttrs names attrs;

  # Take a list of attribute sets, recursively updating them into one.
  recursiveUpdates = builtins.foldl' lib.recursiveUpdate { };

  # Same rules as `lib.mapAttrsRecursiveCond` but also recurses into lists.
  #
  # This implies:
  # 1. The `path` passed to `op` as the first argument may contain indices.
  # 2. The `cond` and `op` must check the type of
  #    the expression it recieves as the second argument.
  mapRecursiveCond = cond: op: expr:
    let
      recurse = path: expr:
        if lib.isList expr && cond expr then
          lib.imap0 (i: recurse (path ++ [ i ])) expr
        else if lib.isAttrs expr && cond expr then
          lib.mapAttrs (name: recurse (path ++ [ name ])) expr
        else
          op path expr;
    in recurse [ ] expr;

  # TODO doc or remove
  thruAttr = attrName: attrs:
    if lib.isAttrs attrs && attrs ? ${attrName} then
      attrs.${attrName}
    else
      attrs;

  # TODO doc or remove
  mapThruAttr = attrName: lib.mapAttrs (name: thruAttr attrName);

  # TODO doc or remove
  mapListToAttrs = fn: attrsList: builtins.listToAttrs (map fn attrsList);

  # Return a list of attribute paths of every deepest non-attriibute-set value.
  attrPaths = attrs:
    let
      recursePaths = path:
        builtins.mapAttrs (name: value:
          if lib.isAttrs value then
            recursePaths (path ++ [ name ]) value
          else
            path ++ [ name ]);
      reduceValues = val:
        if lib.isList val then
          map (it:
            if lib.isAttrs it then
              reduceValues (builtins.attrValues it)
            else
              it) val
        else
          val;
    in lib.pipe attrs [
      (recursePaths [ ])
      lib.toList
      reduceValues
      (lib.flattenCond (builtins.any lib.isList))
    ];
in {
  #
  inherit updates hasAttrs hasExactAttrs recursiveUpdates mapRecursiveCond
    thruAttr mapThruAttr mapListToAttrs attrPaths;
}
