{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-parts }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = {self', inputs', pkgs, system, ... }:
        let
          overlay = self: super: {
            # Local packages in the repository
            foo = self.callCabal2nix "foo" ./foo {};
            bar = self.callCabal2nix "bar" ./bar {};
            # TODO: Put any library dependency overrides here
          };
          # Extend the `pkgs.haskellPackages` attrset using an overlay.
          #
          # Note that we can also extend the package set using more than one
          # overlay. To do that we can either chain the `extend` calls or use
          # the `composeExtensions` (or `composeManyExtensions`) function to
          # merge the overlays.
          haskellPackages' = pkgs.haskellPackages.extend overlay;
        in {
          packages = {
            inherit (haskellPackages') foo bar;
            default = haskellPackages'.bar;
          };
          # This is how we provide a multi-package dev shell in Haskell.
          # By using the `shellFor` function.
          devShells.default = haskellPackages'.shellFor {
            packages = p: [
              p.foo
              p.bar
            ];
            buildInputs = [
              haskellPackages'.ghcid
            ];
          };
        };
    };
}
