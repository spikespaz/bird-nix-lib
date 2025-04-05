{
  description =
    "Experimetal extensions for `lib`, extracted from spikespaz/dotfiles.";

  inputs = {
    # You can set with `follows`:
    # nixpkgs.url = "github:nix-community/nixpkgs.lib";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems }:
    let
      inherit (self) lib;
      eachSystem = lib.genAttrs (import systems);
    in {
      # ```nix
      # let
      #   lib = nixpkgs.lib.extend (inputs.bird-nix-lib.lib.overlay);
      # in
      # ```
      lib = let overlay = import ./lib;
      in nixpkgs.lib.extend overlay // { inherit overlay; };
      # $ nix flake check
      # or
      # $ nix eval 'path:.#tests'
      tests = lib.bird.runTestsRecursive ./tests { inherit lib; } {
        inherit (self.lib.bird) lib;
      };
      # $ nix fmt
      formatter =
        eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-classic);
    };
}
