{ lib }:
lib.bird.mkTestSuite {
  hasAttrs = [
    {
      name = "has all attr names";
      expr = lib.hasAttrs [ "a" "b" "c" ] {
        a = null;
        b = null;
        c = null;
        d = null;
      };
      expect = true;
    }
    {
      name = "does not have all attr names";
      expr = lib.hasAttrs [ "a" "b" "c" "e" ] {
        a = null;
        b = null;
        c = null;
        d = null;
      };
      expect = false;
    }
  ];
  hasExactAttrs = [
    {
      name = "has exactly attr names";
      expr = lib.hasExactAttrs [ "a" "b" "c" ] {
        a = null;
        b = null;
        c = null;
      };
      expect = true;
    }
    {
      name = "has too many attr names";
      expr = lib.hasExactAttrs [ "a" "b" "c" ] {
        a = null;
        b = null;
        c = null;
        d = null;
      };
      expect = false;
    }
    {
      name = "has too few attr names";
      expr = lib.hasExactAttrs [ "a" "b" "c" ] {
        a = null;
        b = null;
      };
      expect = false;
    }
    {
      name = "does not have all attr names";
      expr = lib.hasExactAttrs [ "a" "b" "c" "e" ] {
        a = null;
        b = null;
        c = null;
        d = null;
      };
      expect = false;
    }
  ];
  mapRecursiveCond = let
    attrs = {
      x = {
        r = 255;
        g = 255;
        b = 255;
      };
      y = [
        {
          r = 0;
          g = 0;
          b = 0;
        }
        { n = 1000; }
      ];
      z = null;
    };
    isRGB = x: lib.isAttrs x && lib.hasExactAttrs [ "r" "g" "b" ] x;
  in [
    {
      name = "can behave like mapAttrsRecursiveCond";
      expr = lib.mapRecursiveCond (lib.isAttrs) (_: lib.id) attrs;
      expect = lib.mapAttrsRecursiveCond (_: true) (_: lib.id) attrs;
    }
    {
      name = "can recurse into lists";
      expr = lib.mapRecursiveCond (x: !(isRGB x))
        (_: x: if isRGB x then "rgb" else x) attrs;
      expect = attrs // {
        x = "rgb";
        y = [ "rgb" { n = 1000; } ];
      };
    }
  ];
}
