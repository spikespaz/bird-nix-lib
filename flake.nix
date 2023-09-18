{
  description =
    "Experimetal extensions for `lib`, extracted from spikespaz/dotfiles.";

  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    systems.url = "github:nix-systems/default";
    nixfmt.url = "github:serokell/nixfmt";
  };

  outputs = { self, nixpkgs-lib, systems, nixfmt, ... }:
    let
      lib = nixpkgs-lib.lib.extend (self.lib);
      eachSystem = lib.genAttrs (import systems);
    in {
      lib = import ./lib;
      tests = lib.birdos.runTestsRecursive ./tests { inherit lib; };
      formatter = eachSystem (system: nixfmt.packages.${system}.default);
    };
}
