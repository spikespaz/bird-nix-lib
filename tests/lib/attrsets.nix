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
}
