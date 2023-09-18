{
  description =
    "Experimetal extensions for `lib`, extracted from spikespaz/dotfiles.";

  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    systems.url = "github:nix-systems/default";
    nixfmt.url = "github:serokell/nixfmt";
  };

  outputs = { self, nixpkgs-lib, systems, nixfmt }:
    let
      inherit (self.lib) lib;
      eachSystem = lib.genAttrs (import systems);
    in {
      lib = {
        # ```nix
        # let
        #   lib = nixpkgs.lib.extend (inputs.bird-nix-lib.lib.overlay);
        # in
        # ```
        overlay = import ./lib;
        # ```nix
        # let
        #   lib = inputs.birdos.lib.lib;
        # in
        # ```
        lib = nixpkgs-lib.lib.extend (self.lib.overlay);
      };
      # $ nix flake check
      # or
      # $ nix eval 'path:.#tests'
      tests = lib.birdos.runTestsRecursive ./tests { inherit lib; };
      # $ nix fmt
      formatter = eachSystem (system: nixfmt.packages.${system}.default);
    };
}
