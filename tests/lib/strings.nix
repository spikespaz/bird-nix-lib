{ lib }:
lib.bird.mkTestSuite {
  toPercent = [
    {
      name = "three digits with zero decimals";
      expr = lib.toPercent 0 1.0;
      expect = "100%";
    }
    {
      name = "two digits with zero decimals";
      expr = lib.toPercent 0 0.99;
      expect = "99%";
    }
    {
      name = "one digit with zero decimals";
      expr = lib.toPercent 0 1.0e-2;
      expect = "1%";
    }
    {
      name = "three digits with zeroes stripped";
      expr = lib.toPercent 2 1.00001;
      expect = "100%";
    }
    {
      name = "two digits with zeroes stripped";
      expr = lib.toPercent 2 0.99001;
      expect = "99%";
    }
    {
      name = "one digit with zeroes stripped";
      expr = lib.toPercent 2 1.001e-2;
      expect = "1%";
    }
    {
      name = "five digits with two decimals";
      expr = lib.toPercent 2 1.00005;
      expect = "100.01%";
    }
  ];
}
