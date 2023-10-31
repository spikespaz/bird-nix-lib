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
}
