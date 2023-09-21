{ lib }:
let
  not = a: !a;
  # `and` defined in `lib.trivial`
  nand = a: b: !(a && b);
  # `or` defined in `lib.trivial`
  nor = a: b: !(a || b);
  xor = a: b: (a || b) && !(a && b);
  xnor = a: b: !(a || b) || (a && b);

  # Imply that `cond` is not falsy, if it is,
  # return `default` and otherwise `value`.
  imply = cond: value: implyDefault cond null value;
  implyDefault = cond: default: value:
    if (cond == null)
    # Statix wants to change this to `!c`, do not let it.
    || cond == false
    #
    || cond == { } || cond == [ ] || cond == "" || cond == 0 then
      default
    else
      value;

  applyArgs = lib.foldl' (fn': fn');

  # Given a large attribute set (of arguments),
  # reduce the set to only what the function expects, and apply it.
  applyAutoArgs = fn: attrs:
    let
      fnArgs = lib.functionArgs fn;
      autoArgs = builtins.intersectAttrs fnArgs attrs;
    in fn autoArgs;
in {
  #
  inherit not nand nor xor xnor imply implyDefault applyArgs applyAutoArgs;
}
