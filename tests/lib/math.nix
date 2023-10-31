{ lib }:
lib.bird.mkTestSuite {
  round = [
    {
      name = "remains at tens";
      expr = lib.round 0 1.0;
      expect = 1;
    }
    {
      name = "rounds up to tens";
      expr = lib.round 0 0.5;
      expect = 1;
    }
    {
      name = "rounds down to tens";
      expr = lib.round 0 0.49;
      expect = 0;
    }
    {
      name = "remains at tenths";
      expr = lib.round 1 0.1;
      expect = 0.1;
    }
    {
      name = "rounds up to tenths";
      expr = lib.round 1 5.0e-2;
      expect = 0.1;
    }
    {
      name = "rounds down to tenths";
      expr = lib.round 1 4.9e-2;
      expect = 0.0;
    }
    {
      name = "remains at hundredths";
      expr = lib.round 2 1.0e-2;
      expect = 1.0e-2;
    }
    {
      name = "rounds up to hundredths";
      expr = lib.round 2 5.0e-3;
      expect = 1.0e-2;
    }
    {
      name = "rounds down to hundredths";
      expr = lib.round 2 4.9e-3;
      expect = 0.0;
    }
  ];
}

