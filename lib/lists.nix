{ lib }:
let
  # find indices of item needle in list haystack
  indicesOf = needle: haystack:
    lib.pipe haystack [
      (lib.imap0 (i: v: { inherit i v; }))
      (builtins.filter (c: c.v == needle))
      (map (x: x.i))
    ];

  # Return the index of the first occurrence of element needle
  # found in the list haystack.
  #
  # If element needle is not found in list, return default.
  indexOfDefault = default: needle: haystack:
    let
      idx = lib.foldl'
        (i: el: if i < 0 then if el == needle then -i - 1 else i - 1 else i)
        (-1) haystack;
    in if idx < 0 then default else idx;

  # Same as `indexOfDefault` but using `null` as the default.
  indexOf = indexOfDefault null;

  # get element at n if present, null otherwise
  getElemAt = xs: n:
    if builtins.length xs > n then builtins.elemAt xs n else null;

  removeElems = xs: remove:
    lib.pipe xs [
      (lib.mapListToAttrs (x: lib.nameValuePair x null))
      (xs: removeAttrs xs remove)
      (builtins.listToAttrs)
    ];

  # Takes a starting index and an ending index and returns
  # a new list with the items between that range from `list`.
  # The result is not inclusive of the item at `end`.
  sublist = start: end: list:
    lib.foldl' (acc: i: acc ++ [ (builtins.elemAt list i) ]) [ ]
    (lib.range start (end - 1));

  # split a list-compatible haystack
  # at every occurrence and return
  # a list of slices between occurrences
  split = needle: haystack:
    let
      idxs = indicesOf needle haystack;
      idxs0 = [ 0 ] ++ map (x: x + 1) idxs;
      idxs1 = idxs ++ [ (builtins.length haystack) ];
      pairs = map ({ fst, snd, }: {
        i = fst;
        l = snd - fst;
      }) (lib.zipLists idxs0 idxs1);
    in map ({ i, l, }: lib.sublist i l haystack) pairs;

  # Split a list haystack into separate left and right lists
  # at the position of the first occurrence of element needle.
  #
  # Returns an attribute set with left and right lists as
  # names `r` and `l` respectively.
  #
  # If element needle is not in list, return `null`.
  lsplit = needle: haystack:
    let
      idx = lib.indexOf null needle haystack;
      len = builtins.length haystack;
    in if idx == null then
      null
    else {
      l = sublist 0 idx haystack;
      r = sublist (idx + 1) len haystack;
    };

  # split a list-compatible haystack
  # at the rightmost occurrence of needle
  # returns attrs l and r, each being the respective
  # left or right side of the occurrence of needle
  rsplit = needle: haystack:
    let
      idxs = indicesOf needle haystack;
      idx = lib.imply idxs ((lib.last idxs) + 1);
      len = builtins.length haystack;
    in lib.imply len {
      l = lib.sublist 0 (idx - 1) haystack;
      r = lib.sublist idx (len - 1) haystack;
    };
in {
  #
  inherit indicesOf indexOfDefault indexOf getElemAt removeElems sublist split
    lsplit rsplit;
}
