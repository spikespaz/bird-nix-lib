{ lib }:
lib.bird.mkTestSuite {
  not = [
    {
      name = "not true gives false";
      expr = lib.not true;
      expect = false;
    }
    {
      name = "not false gives true";
      expr = lib.not false;
      expect = true;
    }
  ];
  nand = [
    {
      name = "false nand false gives true";
      expr = lib.nand false false;
      expect = true;
    }
    {
      name = "true nand false gives true";
      expr = lib.nand true false;
      expect = true;
    }
    {
      name = "false nand true gives true";
      expr = lib.nand false true;
      expect = true;
    }
    {
      name = "true nand true gives false";
      expr = lib.nand true true;
      expect = false;
    }
  ];
  nor = [
    {
      name = "false nor false gives true";
      expr = lib.nor false false;
      expect = true;
    }
    {
      name = "true nor false gives false";
      expr = lib.nor true false;
      expect = false;
    }
    {
      name = "false nor true gives false";
      expr = lib.nor false true;
      expect = false;
    }
    {
      name = "true nor true gives false";
      expr = lib.nor true true;
      expect = false;
    }
  ];
  xor = [
    {
      name = "false xor false gives false";
      expr = lib.xor false false;
      expect = false;
    }
    {
      name = "true xor false gives true";
      expr = lib.xor true false;
      expect = true;
    }
    {
      name = "false xor true gives true";
      expr = lib.xor false true;
      expect = true;
    }
    {
      name = "true xor true gives false";
      expr = lib.xor true true;
      expect = false;
    }
  ];
  xnor = [
    {
      name = "false xnor false gives true";
      expr = lib.xnor false false;
      expect = true;
    }
    {
      name = "true xnor false gives false";
      expr = lib.xnor true false;
      expect = false;
    }
    {
      name = "false xnor true gives false";
      expr = lib.xnor false true;
      expect = false;
    }
    {
      name = "true xnor true gives true";
      expr = lib.xnor true true;
      expect = true;
    }
  ];
}
